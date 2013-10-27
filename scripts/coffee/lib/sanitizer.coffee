{object} = require 'utila'

module.exports = sanitizer =

	sanitize: (val) ->

		sanitizer._sanitizeAsChildren val

	_sanitizeAsChildren: (val) ->

		if object.isBareObject val

			return sanitizer._sanitizeObjectAsChildren val

		else if Array.isArray val

			return sanitizer._sanitizeArrayAsChildren val

		else if val is null or typeof val is 'undefined'

			return []

		else if typeof val in ['string', 'number']

			return [String val]

		else

			throw Error "not a valid child node: `#{val}"

	_sanitizeObjectAsChildren: (o) ->

		a = []

		for own key, val of o

			cur = {}

			cur[key] = sanitizer.sanitize val

			a.push cur

		a

	_sanitizeArrayAsChildren: (a) ->

		ret = []

		for v in a

			ret.push sanitizer._sanitizeAsNode v

		ret

	_sanitizeAsNode: (o) ->

		if typeof o in ['string', 'number']

			return String o

		else if object.isBareObject o

			keys = Object.keys(o)

			if keys.length isnt 1

				throw Error "a node must only have one key as tag name"

			key = keys[0]

			obj = {}

			obj[key] = sanitizer._sanitizeAsChildren o[key]

			return obj

		else

			throw Error "not a valid node: `#{o}`"

