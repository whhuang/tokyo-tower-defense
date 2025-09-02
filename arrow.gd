extends Area2D

@export var damage: int = 25
@export var speed: float = 1200          # faster arrows
@export var turn_rate: float = 12.0      # homing turn rate
var direction: Vector2 = Vector2.ZERO
var target: Node2D = null                # assigned by tower

const LAYER_PROJECTILE := 1 << 2
const LAYER_ENEMY := 1 << 3

func _ready() -> void:
	visible = true
	monitoring = true
	monitorable = true
	collision_layer = LAYER_PROJECTILE
	collision_mask = LAYER_ENEMY
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if target != null and is_instance_valid(target):
		var desired: Vector2 = (target.global_position - global_position).normalized()
		var t: float = clamp(turn_rate * delta, 0.0, 1.0)
		direction = direction.lerp(desired, t).normalized()
		rotation = direction.angle()

	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("invader") and area.has_method("take_damage"):
		area.take_damage(damage)
		queue_free()
