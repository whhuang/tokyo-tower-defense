extends Node2D

@export var invader_scene: PackedScene
@export var default_speed = 500.0

var current_speed = 0
signal hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is PlaceTower:
			child.add_to_group("place_tower")
			child.set_disabled(true)
# eren

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$InvaderPath/InvaderPathFollow.progress += current_speed * delta


func enable_place_tower_buttons(enable: bool) -> void:
	for tower in get_tree().get_nodes_in_group("place_tower"):
		tower.set_disabled(not enable)


func new_game() -> void:
	enable_place_tower_buttons(true)
	
	# Invader spawning
	var invader: RigidBody2D = invader_scene.instantiate()
	$InvaderPath/InvaderPathFollow.add_child(invader)
	$InvaderPath/InvaderPathFollow.progress = 0
	current_speed = default_speed
	invader.add_to_group("invader")

func _on_castle_body_entered(body: Node2D) -> void:
	print("castle hit!")
	hit.emit()
	if body.is_in_group("invader"):
		body.queue_free()
		print("free")

func game_over() -> void:
	current_speed = 0
	enable_place_tower_buttons(false)
