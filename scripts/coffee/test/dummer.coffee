require './_prepare'

dummer = mod 'dummer'

describe "input types"

it "should work with objects", ->

	dummer.toDom {}

it "should work with arrays", ->

	dummer.toDom []

it "should not work with other types", ->

	(-> dummer.toDom 'asdfsdf').should.throw Error

describe "_sanitizeInput()"

it "should turn objects into arrays", ->

	o =

		a: 'text'
		b: ['b1', 'b2']
		c:

			d: 'text'
			e: null

	ret = dummer._sanitizeInput(o)

	ret.should.be.like [

		{
			a: 'text'
		}
		{
			b: ['b1', 'b2']
		}
		{
			c: [

				{d: 'text'}
				{e: []}

			]
		}

	]

describe "_children()"

it "should work", ->

	ret = dummer._children [

		{
			a: 'text'
		}
		{
			'b.someClass': ['b1', 'b2']
		}
		{
			c: [

				{d: 'text'}
				{e: []}

			]
		}

	]

	ret.should.be.an 'array'
	ret.should.have.length.of 3

	for node in ret

		node.should.be.an 'object'
		node.should.have
		.keys ['type', 'name', 'attribs', 'children', 'next', 'prev', 'parent']

	a = ret[0]

	a.children.should.be.an 'array'
	a.children.should.have.length.of 1

	aChild = a.children[0]
	aChild.should.be.an 'object'
	aChild.should.be.like {type: 'text', data: 'text'}

	expect(a.prev).to.equal null
	expect(a.parent).to.equal null

	b = ret[1]

	a.next.should.equal b
	b.prev.should.equal a
	b.attribs.should.be.like

		class: 'someClass'

	bChildren = b.children

	bChildren[0].should.be.like {type: 'text', data: 'b1'}
	bChildren[1].should.be.like {type: 'text', data: 'b2'}

	ret.should.have.deep.property '[2].children[1].name', 'e'

describe "_parseTag"

it "should work", ->

	dummer.
	_parseTag('tagName#id.c1.c2[a=b, d="1 2 3"]')
	.should.be.like

		name: 'tagName'

		attribs:

			id: 'id'

			class: 'c1 c2'
