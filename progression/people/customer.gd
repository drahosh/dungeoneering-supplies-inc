extends RefCounted

class_name Customer
enum CUSTOMER_TYPE {
	BUYING,
	SELLING,
}
var type: CUSTOMER_TYPE
var item: CraftedItem
var amount: int
var hero_class: HeroClass


func _init(p_type, p_item, p_hero_class, p_amount = 1):
	type = p_type
	item = p_item
	hero_class = p_hero_class
	amount = p_amount
