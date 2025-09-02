extends Button

@export var arrow_scene: PackedScene
@export var arrow_speed = 500
var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FiringTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func stop() -> void:
	$FiringTimer.stop()


func _on_firing_timer_timeout() -> void:
	var invaders = get_tree().get_nodes_in_group("invader")
	if invaders.size() > 0:
		target = invaders[0]
		shoot_arrow()


func shoot_arrow():
	if target == null:
		return
	var arrow_instance: RigidBody2D = arrow_scene.instantiate()
	arrow_instance.position = Vector2(50.0, 50.0)
	
	# compute direction
	var direction = (target.global_position - global_position).normalized()
	var angle = atan2(direction[1], direction[0])
	arrow_instance.rotate(angle)

	arrow_instance.linear_velocity = direction * arrow_speed
	
	add_child(arrow_instance)
