extends Area2D


signal invader_hit(instance)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("invaders")
	$AnimatedSprite2D.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	invader_hit.emit(body)
	queue_free()  # TODO: don't delete upon first hit, decrement from health
