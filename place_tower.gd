extends Control
class_name PlaceTower

@export var arrow_tower_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlaceTowerButton/TowerSelectPanel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_disabled(disabled: bool) -> void:
	if disabled:
		$PlaceTowerButton.button_pressed = false
	$PlaceTowerButton.set_disabled(disabled)
	for tower in get_tree().get_nodes_in_group("tower"):
		tower.stop()


func _on_place_tower_button_toggled(toggled_on: bool) -> void:
	$PlaceTowerButton/TowerSelectPanel.visible = toggled_on	


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if $PlaceTowerButton/TowerSelectPanel.visible:
			var panel_rect = $PlaceTowerButton/TowerSelectPanel.get_global_rect()
			if not panel_rect.has_point(event.position):
				$PlaceTowerButton.button_pressed = false


func _on_arrow_tower_select_pressed() -> void:
	# Become arrow tower
	$PlaceTowerButton.button_pressed = false
	$PlaceTowerButton.visible = false
	var tower = arrow_tower_scene.instantiate()
	add_child(tower)
	tower.add_to_group("tower")


func reset_tower_button() -> void:
	$PlaceTowerButton.visible = true
	set_disabled(true)
	for tower in get_tree().get_nodes_in_group("tower"):
		tower.queue_free()
