extends StaticBody2D

var down = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(_area):
	if down == false:
		$AnimationPlayer.play("Grass_Flat_Left")
		down = true

func _on_Area2D_area_exited(_area):
	if down == true:
		$AnimationPlayer.play("Grass_Up_Left")
		down = false


func _on_Area2D2_area_entered(_area):
	if down == false:
		$AnimationPlayer.play("Grass_Flat_Right")
		down = true


func _on_Area2D2_area_exited(_area):
	if down == true:
		$AnimationPlayer.play("Grass_Up_Right")
		down = false
