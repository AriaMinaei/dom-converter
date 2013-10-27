{object} = require 'utila'
sanitizer = require './sanitizer'

module.exports = dummer =

	toDom: (o) ->

		unless Array.isArray o

			unless object.isBareObject o

				throw Error "toDom() only accepts arrays and bare objects as input"

		o = sanitizer.sanitize o

		dummer._children o

	_children: (a, parent = null) ->

		children = []

		prev = null

		for v in a

			if typeof v is 'string'

				node = dummer._textNode v

			else

				node = dummer._objectToDom v, parent

				node.prev = null
				node.next = null
				node.parent = parent

				if prev?

					node.prev = prev
					prev.next = node

				prev = node

			children.push node

		children

	_objectToDom: (o) ->

		i = 0

		for own k, v of o

			if i > 0

				throw Error "_objectToDom() only accepts an object with one key/value"

			key = k
			val = v

			i++

		node = {}

		if typeof key isnt 'string'

			throw Error "_objectToDom()'s key must be a string of tag name and classes"

		if typeof val is 'string'

			children = [dummer._textNode(val)]

		else if Array.isArray val

			children = dummer._children val, node

		else

			inspect o
			throw Error "_objectToDom()'s key's value must only be a string or an array"

		node.type = 'tag'
		{name, attribs} = dummer._parseTag key
		node.name = name
		node.attribs = attribs
		node.children = children

		node

	_textNode: (s) ->

		{type: 'text', data: s}

	_nameRx: /^[a-zA-Z\-\_]{1}[a-zA-Z0-9\-\_]*$/

	_parseTag: (k) ->

		# validate
		if not k.match(/^[a-zA-Z0-9\#\-\_\.\[\]\"\'\=\,\s]+$/) or k.match(/^[0-9]+/)

			throw Error "cannot parse tag `#{k}`"

		attribs = {}

		parts =

			name: ''

			attribs: attribs

		# tag name
		if m = k.match /^([^\.#]+)/

			name = m[1]

			unless name.match dummer._nameRx

				throw Error "tag name `#{name}` is not valid"

			parts.name = name

			k = k.substr name.length, k.length

		# tag id
		if m = k.match /^#([a-zA-Z0-9\-]+)/

			id = m[1]

			unless id.match dummer._nameRx

				throw Error "tag id `#{id}` is not valid"

			attribs.id = id

			k = k.substr id.length + 1, k.length

		classes = []

		while m = k.match /\.([a-zA-Z0-9\-\_]+)/

			cls = m[1]

			unless cls.match dummer._nameRx

				throw Error "tag class `#{cls}` is not valid"

			classes.push cls

			k = k.replace '.' + cls, ''

		if classes.length

			attribs.class = classes.join " "

		# TODO: match attributes

		parts