extends Node2D

@export var invader_scene: PackedScene
@export var default_speed = 100.0

var current_speed = 0
signal castle_hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is PlaceTower:
			child.add_to_group("place_tower")
			child.set_disabled(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for path_follow in get_tree().get_nodes_in_group("path_follow"):
		path_follow.progress += current_speed * delta


func enable_place_tower_buttons(enable: bool) -> void:
	for tower in get_tree().get_nodes_in_group("place_tower"):
		tower.set_disabled(not enable)


func new_game() -> void:
	enable_place_tower_buttons(true)
	$InvaderSpawnTimer.start()
	
	
func _on_invader_spawn_timer_timeout() -> void:
	var path_follow := PathFollow2D.new()
	$InvaderPath.add_child(path_follow)
	path_follow.progress = 0
	path_follow.add_to_group("path_follow")
	
	var invader: Area2D = invader_scene.instantiate()
	path_follow.add_child(invader)
	current_speed = default_speed
	invader.add_to_group("invader")


func _on_castle_area_entered(area: Area2D) -> void:
	if area.is_in_group("invader"):
		castle_hit.emit()
		area.queue_free()



func game_over() -> void:
	current_speed = 0
	$InvaderSpawnTimer.stop()
	for tower in get_tree().get_nodes_in_group("place_tower"):
		tower.set_disabled(true)

		
func reset_game_state() -> void:
	for tower in get_tree().get_nodes_in_group("place_tower"):
		tower.reset_tower_button()
	for invader in get_tree().get_nodes_in_group("invader"):
		invader.queue_free()
