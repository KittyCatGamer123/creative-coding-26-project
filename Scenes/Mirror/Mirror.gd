@tool
extends Node3D
class_name Mirror

@export var size: Vector2 = Vector2.ONE:
	set(v):
		size = v
		$Quad.mesh.size = size
		$SubViewport.size = size * pixels_per_unit
@export var pixels_per_unit: int = 20
@export var cull_near: float = 0.05
@export var cull_far: float = 50.0
@export_flags_3d_render var cull_mask: int = 0xFFFFF
@export var max_update_distance: float = 50.0

var player_camera: Camera3D
var last_main_camera_position: Vector3

func _ready() -> void:
	if Engine.is_editor_hint():
		player_camera = Engine.get_singleton(&"EditorInterface").get_editor_viewport_3d().get_camera_3d()
	else:
		player_camera = get_viewport().get_camera_3d()
	
	last_main_camera_position = player_camera.position
	setup()
	update_cam()

func _process(delta: float) -> void:
	if not is_visible_in_tree(): return
	if not is_instance_valid(player_camera): return
	if last_main_camera_position.distance_to(player_camera.global_position) < 0.01: return
	
	last_main_camera_position = player_camera.global_position
	var diff = global_position - last_main_camera_position
	if diff.length() > max_update_distance:
		$SubViewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	else:
		$SubViewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	update_cam()

func setup() -> void:
	var viewport_texture = $SubViewport.get_texture()
	$SubViewport/Camera3D.cull_mask = cull_mask
	$SubViewport/Camera3D.fov = player_camera.fov
	$Quad.mesh.size = size
	$SubViewport.size = size * pixels_per_unit
	$Quad.get_active_material(0).set_shader_parameter(&"tex", viewport_texture)

func update_cam() -> void:
	var mirror_normal = $Quad.global_basis.z
	var mirror_transform = get_mirror_transform(mirror_normal, global_position)
	$SubViewport/Camera3D.global_transform = mirror_transform * player_camera.global_transform
	
	$SubViewport/Camera3D.global_transform = $SubViewport/Camera3D.global_transform.looking_at(
		$SubViewport/Camera3D.global_position / 2.0 + last_main_camera_position / 2.0, 
		$Quad.global_basis.y
	)
	var camera_to_mirror_offset = $Quad.global_position - $SubViewport/Camera3D.global_position
	
	var near = abs(camera_to_mirror_offset.dot(mirror_normal)) + cull_near
	var far = camera_to_mirror_offset.length() + cull_far
	var cam_to_mirror_offset_camera_local = $SubViewport/Camera3D.global_basis.inverse() * camera_to_mirror_offset
	var frustum_offset = Vector2(cam_to_mirror_offset_camera_local.x, cam_to_mirror_offset_camera_local.y)
	$SubViewport/Camera3D.set_frustum(size.x, frustum_offset, near, far)

static func get_mirror_transform(normal: Vector3, offset: Vector3) -> Transform3D:
	var basis_x = Vector3.RIGHT - (2 * Vector3(normal.x * normal.x, normal.x * normal.y, normal.x * normal.z))
	var basis_y = Vector3.UP - (2 * Vector3(normal.y * normal.x, normal.y * normal.y, normal.y * normal.z))
	var basis_z = Vector3.BACK - (2 * Vector3(normal.z * normal.x, normal.z * normal.y, normal.z * normal.z))
	var origin = 2 * normal.dot(offset) * normal
	return Transform3D(basis_x, basis_y, basis_z, origin)
	
	
	
