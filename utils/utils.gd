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


static func get_screen_top_margin(node: Node) -> int:
	# For phones, returns size of margin on top needed to not be covered by notch on top of screen
	var safe = DisplayServer.get_display_safe_area()
	var scale_y = node.get_viewport().get_stretch_transform().y.y
	return ceil(safe.position.y / scale_y)
