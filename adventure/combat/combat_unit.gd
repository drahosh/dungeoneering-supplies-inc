extends CharacterBody3D

class_name CombatUnit
var stats: Dictionary
var current_health: int
@export var hp_bar: TextureProgressBar
const is_ally = false

# damage reductions
var dr_phys: float # percentage of initial damage received
var dr_mag: float

var location = Vector3()

# components
@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $CollisionShape3D
@onready var navigation_agent = $NavigationAgent3D


func _ready() -> void:
	current_health = stats[Enums.STATS.HP]
	hp_bar.max_value = current_health
	hp_bar.value = current_health
	recalculate_damage_resistances()


func recalculate_damage_resistances():
	dr_phys = (stats[Enums.STATS.ARMOR] + 100.0) / 100.0
	dr_mag = (stats[Enums.STATS.MAGIC_RES] + 100.0) / 100.0


func take_damage(damage: float, damage_type: Enums.ATTACK_TYPE):
	match damage_type:
		Enums.DAMAGE_TYPE.PHYS:
			damage = round(damage / dr_phys)
		Enums.DAMAGE_TYPE.MAGIC:
			damage = round(damage / dr_mag)
	change_health(-int(damage))


func change_health(change: int):
	current_health = clamp(current_health + change, 0, stats[Enums.STATS.HP])
	if current_health == 0:
		die()


func die():
	# TODO animation
	self.queue_free()


func _physics_process(delta: float) -> void:
	# TODO
	pass
