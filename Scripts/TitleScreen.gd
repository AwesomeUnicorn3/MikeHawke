extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_New_Game_pressed():
	SoundEffects.select()

	Save_Game.new_game()
	Save_Game.save_game()
	get_node("/root/Global").setScene("res://Scenes/IndoorMaps/House-Mike.tscn")


func _on_Load_Game_pressed():
	SoundEffects.select()
	Save_Game.load_game()
	Global.setScene("res://Scenes/LoadGame.tscn")


func _on_ConfirmationDialog_confirmed():
	Save_Game.save_game()
	get_node("/root/Global").setScene("res://Scenes/IndoorMaps/House-Mike.tscn")


func _on_Options_pressed():
	pass # Replace with function body.
