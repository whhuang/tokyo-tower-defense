extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_lives(lives):
	$LivesLabel.text = str(lives)
	

func update_cash(cash):
	$CashLabel.text = str(cash)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$GameOverLabel.hide()
	start_game.emit()
	

func game_over() -> void:
	$GameOverLabel.show()
	$GameOverTimer.start()


func _on_game_over_timer_timeout() -> void:
	$GameOverLabel.hide()
	$StartButton.show()
