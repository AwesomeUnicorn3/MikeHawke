extends StaticBody2D
export (Texture) var face
signal reparent
export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

var dict = Global.Dict_objects_fruitville   #set this to the dict of the item
#export var item = "Sticky Aluminum" #Change if there is an item drop
#export var dialogue_variable = "cans" #change this to variable from dialogue script

var location = "fruitville" 
var me
var id
var selected = false
var talking = false
var interacting = false

var pos = Vector2()
var load_me = false


func on_not_interacted_item_load(): #on load if item has *NOT* been interacted with by player
	dict[id]["active"] = true

func on_interacted_item_load(): #on load if item has been interacted with by player
	load_me = true
	pos.x = dict[id]["positionx"]
	pos.y = dict[id]["positiony"]



#END FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#the below functions should not be changed in most cases
func _ready():
	pos = get_position()
	me = self
	id = self.get_name()
	$DungBeetle/AnimationPlayer.play("Dead")
	var this_dict = {"id": id, "active":true, "positionx":pos.x, "positiony":pos.y}
	if dict.keys().has(id) == false:
		dict[id] = this_dict
		on_not_interacted_item_load()
	else:
		on_interacted_item_load()


# warning-ignore:unused_argument
func _process(delta):
	if load_me == true:
		set_global_position(Vector2(pos.x, pos.y))
		load_me = false
	pos = get_global_position()
	if Global.carry == false:
		if dict[id]["positionx"] != pos.x or dict[id]["positiony"] != pos.y:
			dict[id]["positionx"] = pos.x
			dict[id]["positiony"] = pos.y


# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_pressed("ui_select"):
		if get_parent() == MSG.level_root().get_node("main/Mike Hawke"):
			throw()




func interact():
	var new_parent = MSG.level_root().get_node("main/Mike Hawke")
	var node = $'.'
	call_deferred("reparent",node, new_parent)
	yield(self, "reparent")
	node.set_position(Vector2(-15, -60))
	Global.carry = true
	MSG.msg_ended()




func throw():
	var mike =  MSG.level_root().get_node("main/Mike Hawke")
	var node = $"."
	var new_parent = MSG.level_root().get_node("main")
	var drop = mike.drop_pos
	call_deferred("reparent",node, new_parent)
	yield(self, "reparent")
	set_global_position(Vector2(Global.PlayerX + drop.x, Global.PlayerY + drop.y))
	Global.carry = false
	MSG.msg_ended()

#	var t = Timer.new()
#	self.add_child(t)
#	t.set_one_shot(true)
#	t.set_wait_time(1)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()


func reparent(node, new_parent):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	emit_signal("reparent")
