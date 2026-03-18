extends CharacterBody3D

@onready var animation: AnimationPlayer = $warrior_decimated/AnimationPlayer
@onready var navigation: NavigationAgent3D = $NavigationAgent3D

@onready var friendly := true if self.is_in_group('allies') else false

var target: Node3D = null

const RETARGET_COOLDOWN: float = 1.0

@export var MOVE_SPEED: float = 50.0

var _retarget_timer: float = 1.0


func _ready() -> void:
	navigation.velocity_computed.connect(_on_velocity_computed)
	animation.play("walk")
	animation.animation_finished.connect(func(_x): animation.play("walk"))


func _process(p_delta: float) -> void:
	_retarget_timer += p_delta
	if _retarget_timer > RETARGET_COOLDOWN:
		# Don't reset the target position every frame. It triggers an A* search, which is expensive.
		_retarget_timer = 0.0
		target_nearest_enemy()
		if target:
			navigation.set_target_position(target.global_position)


func target_nearest_enemy() -> void:
	var enemy_distance = self.global_position.distance_to(target.global_position) if target else 0
	var enemies
	if friendly:
		enemies = get_tree().get_nodes_in_group('enemies')
	else:
		enemies = get_tree().get_nodes_in_group('allies')
	for node in enemies:
		if target == null or target != node:
			var new_distance = self.global_position.distance_to(node.global_position)
			if new_distance < enemy_distance or !target:
				target = node
				enemy_distance = new_distance


func _on_velocity_computed(p_safe_velocity: Vector3) -> void:
	velocity.x = p_safe_velocity.x
	velocity.z = p_safe_velocity.z
	move_and_slide()
	look_at(global_position + velocity)


func _physics_process(p_delta: float) -> void:
	if navigation.is_navigation_finished():
		velocity.x = 0.0
		velocity.z = 0.0
	else:
		var next_path_position: Vector3 = navigation.get_next_path_position()
		var current_agent_position: Vector3 = global_position
		var velocity_xz := (next_path_position - current_agent_position).normalized() * MOVE_SPEED
		velocity.x = velocity_xz.x
		velocity.z = velocity_xz.z

	velocity.y -= 40 * p_delta

	if navigation.avoidance_enabled:
		navigation.set_velocity(velocity)
	else:
		_on_velocity_computed(velocity)

	# Ensure enemy doesn't fall through terrain when collision absent
	if get_parent().terrain:
		var height: float = get_parent().terrain.data.get_height(global_position)
		if not is_nan(height):
			global_position.y = maxf(global_position.y, height)
