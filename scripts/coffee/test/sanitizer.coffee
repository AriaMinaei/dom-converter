require './_prepare'

sanitizer = mod 'sanitizer'

describe "sanitize()"

test "case: 'text'", ->

	input = 'text'

	expectation = ['text']

	ret = sanitizer.sanitize input

	ret.should.be.like expectation

test "case: ['text']", ->

	input = ['text']

	expectation = ['text']

	ret = sanitizer.sanitize input

	ret.should.be.like expectation

test "case: {a:b}", ->

	input = a: 'b'

	expectation = [{a: ['b']}]

	ret = sanitizer.sanitize input

	ret.should.be.like expectation

test "case: {a:[b: 'c']}", ->

	input = a: [b: 'c']

	expectation = [{a: [{b: ['c']}]}]

	ret = sanitizer.sanitize input

	ret.should.be.like expectation

test "case: {a:b: 'c'}", ->

	input = a: b: 'c'

	expectation = [{
		a: [{
			b: ['c']
		}]
	}]

	ret = sanitizer.sanitize input

	ret.should.be.like expectation

test "case: {a:b: ['c', d: 'e']}", ->

	input = a: b: ['c', d: 'e']

	expectation = [{
		a: [{
			b: ['c', {d: ['e']}]
		}]
	}]

	ret = sanitizer.sanitize input

	ret.should.be.like expectation