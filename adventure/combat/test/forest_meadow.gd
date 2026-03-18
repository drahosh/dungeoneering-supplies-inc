## forest_meadow.gd
## Attached to the ForestMeadow root node.
## Handles procedural tree placement, grass MultiMesh generation, and
## optional top-down camera zoom via scroll wheel.

extends Node3D

# ── Export tweaks ──────────────────────────────────────────────────────────
@export var meadow_radius: float       = 30.0   ## Clear meadow radius (no trees)
@export var forest_radius: float       = 60.0   ## Outer forest radius
@export var pine_count: int            = 180
@export var oak_count: int             = 40
@export var grass_blade_count: int     = 8000
@export var grass_spread: float        = 25.0   ## Half-extent of grass patch
@export var camera_zoom_speed: float   = 5.0
@export var camera_zoom_min: float     = 20.0
@export var camera_zoom_max: float     = 150.0

@export var pine_scene: PackedScene    = preload("res://assets/trees/pine_tree.tscn")
@export var oak_scene: PackedScene     = preload("res://assets/trees/oak_tree.tscn")

# ── Internal refs ──────────────────────────────────────────────────────────
@onready var terrain: Terrain3D              = $Terrain3D
@onready var pine_root: Node3D               = $FoliageRoot/PineForest
@onready var oak_root: Node3D               = $FoliageRoot/OakScatter
@onready var grass_mmi: MultiMeshInstance3D  = $GrassMesh
@onready var camera: Camera3D               = $TopDownCamera

var _rng := RandomNumberGenerator.new()

# ──────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	_rng.randomize()
	_place_trees()
	_build_grass_multimesh()


func _input(event: InputEvent) -> void:
	# Scroll-wheel zoom for the orthographic top-down camera
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.size = clampf(camera.size - camera_zoom_speed, camera_zoom_min, camera_zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.size = clampf(camera.size + camera_zoom_speed, camera_zoom_min, camera_zoom_max)


# ── Tree placement ─────────────────────────────────────────────────────────
func _place_trees() -> void:
	_scatter_trees(pine_scene, pine_root, pine_count,
			meadow_radius + 4.0, forest_radius, 1.0, 2.5)
	_scatter_trees(oak_scene,  oak_root,  oak_count,
			meadow_radius * 0.6, meadow_radius * 0.95, 0.8, 1.6)


func _scatter_trees(
		scene: PackedScene,
		parent: Node3D,
		count: int,
		r_min: float,
		r_max: float,
		scale_min: float,
		scale_max: float
) -> void:
	if scene == null:
		return
	for _i in count:
		var angle := _rng.randf() * TAU
		var dist  := sqrt(_rng.randf()) * (r_max - r_min) + r_min
		var pos   := Vector3(cos(angle) * dist, 0.0, sin(angle) * dist)

		# Snap Y to terrain surface
		pos.y = _get_terrain_height(pos)

		var tree: Node3D = scene.instantiate()
		parent.add_child(tree)
		tree.global_position = pos

		var s := _rng.randf_range(scale_min, scale_max)
		tree.scale = Vector3(s, s, s)
		tree.rotation.y = _rng.randf() * TAU


# ── Grass MultiMesh ────────────────────────────────────────────────────────
func _build_grass_multimesh() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count   = grass_blade_count

	# Simple upright quad as a blade stand-in (replace with a proper mesh)
	var quad := QuadMesh.new()
	quad.size = Vector2(0.15, 0.4)
	mm.mesh = quad

	for i in grass_blade_count:
		var x := _rng.randf_range(-grass_spread, grass_spread)
		var z := _rng.randf_range(-grass_spread, grass_spread)
		var y := _get_terrain_height(Vector3(x, 0.0, z))
		var t  := Transform3D(Basis(), Vector3(x, y, z))
		t.basis = t.basis.rotated(Vector3.UP, _rng.randf() * TAU)
		mm.set_instance_transform(i, t)

	grass_mmi.multimesh = mm


# ── Helpers ────────────────────────────────────────────────────────────────
func _get_terrain_height(world_pos: Vector3) -> float:
	## Returns the terrain surface Y for a given XZ world position.
	## Falls back to 0.0 if Terrain3D storage is unavailable.
	if terrain == null or terrain.storage == null:
		return 0.0
	return terrain.storage.get_height(world_pos)
