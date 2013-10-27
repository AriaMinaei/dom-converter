{object} = require 'utila'

module.exports = dummer =

	toDom: (o) ->

		unless Array.isArray o

			unless object.isBareObject o

				throw Error "toDom() only accepts arrays and bare objects as input"

			o = dummer._objectToArray o

		dummer._children o

	_objectToArray: (o) ->

		a = []

		for own key, val of o

			cur = {}

			cur[key] = dummer._sanitizeInput val

			a.push cur

		a

	_sanitizeInput: (val) ->


		if object.isBareObject val

			return dummer._objectToArray val

		else if Array.isArray val

			return dummer._sanitizeArrayInput val

		else if val is null or typeof val is 'undefined'

			return []

		else

			return val

	_sanitizeArrayInput: (a) ->

		ret = []

		for v in a

			ret.push dummer._sanitizeInput v

		ret


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

			throw Error "_objectToDom()'s key's value must only be a string or an array"

		node.type = 'tag'
		node.name = key
		node.attribs = {}
		node.children = children

		node

	_textNode: (s) ->

		{type: 'text', data: s}