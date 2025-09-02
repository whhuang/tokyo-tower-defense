extends Button

@export var arrow_scene: PackedScene
@export var arrow_speed: float = 1200.0
@export var range: float = 220.0
@export var focus_fire: bool = false
@export var use_range_gate: bool = false

var target: Node2D = null

func _ready() -> void:
	# Clickable/toggleable
	toggle_mode = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	if not toggled.is_connected(_on_toggled):
		toggled.connect(_on_toggled)

	# Connect remove button (adjust the path if yours is different)
	if has_node("TowerSelectPanel/RemoveProjectile"):
		var rb: Button = $"TowerSelectPanel/RemoveProjectile"
		if not rb.pressed.is_connected(_on_remove_projectile_pressed):
			rb.pressed.connect(_on_remove_projectile_pressed)

	# Fire timer
	if has_node("FiringTimer"):
		var t: Timer = $FiringTimer
		if not t.timeout.is_connected(_on_firing_timer_timeout):
			t.timeout.connect(_on_firing_timer_timeout)
		t.start()

	# Start closed
	if has_node("TowerSelectPanel"):
		$TowerSelectPanel.visible = false

func _on_toggled(on: bool) -> void:
	if has_node("TowerSelectPanel"):
		$TowerSelectPanel.visible = on

func stop() -> void:
	if has_node("FiringTimer"):
		$FiringTimer.stop()

func _on_firing_timer_timeout() -> void:
	if focus_fire:
		if not _is_valid_target(target):
			target = _pick_most_advanced()
	else:
		target = _pick_most_advanced()

	if _is_valid_target(target):
		_shoot_arrow()

# ------------ Remove / refund ------------

func _on_remove_projectile_pressed() -> void:
	# refund half the cost if set by PlaceTower
	if has_meta("cost"):
		var main = get_tree().root.get_node("Main")
		var cost: int = int(get_meta("cost"))
		main.cash += cost / 2

	# return this PlaceTower spot back to button state
	var pt = get_parent()
	if pt and pt.has_method("reset_tower_button"):
		pt.reset_tower_button()

	# remove this tower
	queue_free()

# ----------------- Helpers -----------------

func _world_pos() -> Vector2:
	return get_global_transform_with_canvas().origin

func _is_valid_target(t) -> bool:
	if t == null or not is_instance_valid(t):
		return false
	if not use_range_gate:
		return true
	var origin := _world_pos()
	return origin.distance_squared_to(t.global_position) <= range * range

func _progress_of(inv: Node2D) -> float:
	var pf := inv.get_parent()
	return pf.progress if pf is PathFollow2D else 0.0

func _pick_most_advanced() -> Node2D:
	var invs: Array = get_tree().get_nodes_in_group("invader")
	if invs.is_empty():
		return null
	var origin := _world_pos()
	var best: Node2D = null
	var best_score := -INF
	for inv in invs:
		if not is_instance_valid(inv):
			continue
		if use_range_gate:
			var d2 := origin.distance_squared_to(inv.global_position)
			if d2 > range * range:
				continue
		var score := _progress_of(inv) - origin.distance_squared_to(inv.global_position) * 1e-6
		if score > best_score:
			best_score = score
			best = inv
	return best

func _world_parent() -> Node:
	var root := get_tree().root
	if root.has_node("Main/Map/Projectiles"):
		return root.get_node("Main/Map/Projectiles")
	if root.has_node("Main/Map"):
		return root.get_node("Main/Map")
	return get_tree().current_scene

# ----------------- Shooting -----------------

func _shoot_arrow() -> void:
	if target == null or not is_instance_valid(target) or arrow_scene == null:
		return

	var arrow = arrow_scene.instantiate()
	var wp := _world_parent()
	wp.add_child(arrow)

	arrow.top_level = true
	var spawn_pos := _world_pos()
	arrow.global_position = spawn_pos

	var dir: Vector2 = (target.global_position - spawn_pos).normalized()
	arrow.direction = dir
	arrow.speed = arrow_speed
	arrow.rotation = dir.angle()

	if "target" in arrow:
		arrow.target = target
