extends Node

# Autoloaded as DayManager

enum PHASE {
	SHOPKEEPING,
	GATHERING,
	ADVENTURE,
}
var current_day = 0
var phase: PHASE # used for saving
# Day starts in shopkeeping phase. After that, we go to gathering or adventure. After that ends, new day begins


func start_day():
	current_day += 1
	phase = PHASE.SHOPKEEPING
	Guilds.generate_customers()


func start_gathering():
	phase = PHASE.GATHERING


func start_adventure():
	phase = PHASE.ADVENTURE
