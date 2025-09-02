extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for invader in get_tree().get_nodes_in_group("invader"):
		invader.invader_hit.connect(_on_invader_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_invader_hit(node: Node2D) -> void:
	if self == node:
		queue_free()
