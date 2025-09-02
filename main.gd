extends Node

@export var starting_lives = 20
@export var starting_cash = 10
@export var cash_increment = 10
var game_in_progress
var lives
var cash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_in_progress = false
	lives = starting_lives
	cash = starting_cash


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$HUD.update_lives(lives)
	$HUD.update_cash(cash)
	if lives == 0 and game_in_progress:
		game_over()


func new_game() -> void:
	$Map.reset_game_state()
	game_in_progress = true
	lives = starting_lives
	cash = starting_cash
	$CashTimer.start()
	$Map.new_game()


func _on_cash_timer_timeout() -> void:
	cash += cash_increment


func _on_map_castle_hit() -> void:
	lives -= 1


func game_over():
	game_in_progress = false
	$CashTimer.stop()
	$HUD.game_over()
	$Map.game_over()
	$GameOverTimer.start()
