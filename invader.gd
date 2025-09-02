extends Area2D

@export var health: int = 50
@export var cash_reward: int = 20

const LAYER_PROJECTILE := 1 << 2
const LAYER_ENEMY := 1 << 3

var velocity: Vector2 = Vector2.ZERO
var _prev_pos: Vector2

func _ready() -> void:
	add_to_group("invader")
	collision_layer = LAYER_ENEMY
	collision_mask = LAYER_PROJECTILE
	$AnimatedSprite2D.play("walk")
	_prev_pos = global_position

func _process(delta: float) -> void:
	var p := global_position
	if delta > 0.0:
		velocity = (p - _prev_pos) / delta
	_prev_pos = p

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	var main = get_tree().root.get_node("Main")
	main.cash += cash_reward
	queue_free()
