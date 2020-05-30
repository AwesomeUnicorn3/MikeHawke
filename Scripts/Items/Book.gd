extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var color = []
	var rand_num

	for i in $".".get_children():
		if i.get_name() == "Shadow":
			pass
		else:
			color = color + [i.get_name()]
	rand_num = rand_range(0, color.size())
	var book_sprite = color[rand_num]
	get_node(book_sprite).visible = true

