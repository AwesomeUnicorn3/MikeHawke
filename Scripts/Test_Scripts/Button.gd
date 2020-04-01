extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var chode = get_node("../../BottomLeftGui/HBoxContainer/ChodeCount")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	var cost = -50
	if (Global.Chode + cost) < 0:
		print("You do not have enough Chode")
	else:
		chode.change_chode(cost)
