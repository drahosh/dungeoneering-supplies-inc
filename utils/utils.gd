extends Object

class_name Utils

static func stats_to_string(stats: Dictionary, full := false) -> String:
	var strings = []
	for stat_name in Enums.STATS:
		var stat = Enums.STATS[stat_name]
		if stat in stats:
			strings.append("%s: %s" % [stat_name, stats[stat]])
		else:
			if full:
				strings.append("%s: 0" % stat_name)
	return "\n".join(strings)
