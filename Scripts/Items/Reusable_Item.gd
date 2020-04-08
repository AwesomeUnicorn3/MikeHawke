#Item Template
#!!!!DO NOT CHANGE ANYTHING BEFORE SAVING SCRIPT WITH ITEM NAME!!!!

extends StaticBody2D
export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE


var location = "fruitville"  #Set to the name of the map **must be all lower case
var dict = Global.Dict_objects_ + location   #set this to the dict of the item
var item = "Sticky Aluminum" #Change if there is an item drop
var dialogue_variable = "cans" #change this to variable from dialogue script
var num_items_dropped = 1

var me
var id
var selected = false
var talking = false
var interacting = false

#FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#change this for each item
func item_script():
	MSG.start_dialogue(interaction_script, self)
	if dict[id] != false:
		sound_effect()
		item_drops()
		dict[id] = false

func item_drops():
	if not ImportData.inven_data.has(item):
		ImportData.inven_data[item] = [item, 0]
#	ImportData.inven_data[item][1] += MSG.var(dialogue_variable) 


#us if assigning the number of dropped items in the script 
	ImportData.inven_data[item][1] += num_items_dropped


func sound_effect():
	pass
#	SoundEffects.can_rattle() #change sound effect


func on_not_interacted_item_load(): #on load if item has *NOT* been interacted with by player
	pass

func on_interacted_item_load(): #on load if item has been interacted with by player
	self.queue_free()

	

#END FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#the below functions should not be changed in most cases
func _ready():
	me = self
	id = self.get_name()
	if dict.has(id) == false:
		dict[id] = true
	if dict[id] == true:
		on_not_interacted_item_load()
	else:
		on_interacted_item_load()

func _process(delta):
	if self.talking == true:
		pass
	elif self.selected == true:
		talk()


func talk():
	if Global.CanInteract == false:
		pass
	else:
		self.talking = true
		self.selected= false
		Global.CanInteract = false
		Global.PlayerCanMove = false
		item_script()
		yield(MSG, "message_ended")
		Global.CanInteract = true
		Global.body = null
		Global.CanTalk = true
		self.talking = false
		Global.PlayerCanMove = true
		on_interacted_item_load()

func _input(event):
	if me == Global.body:
		if Input.is_action_pressed("ui_select"):
			self.selected = true
	if Input.is_action_just_released("ui_select"):
		self.selected = false





func _on_Area2D_body_exited(body):
	Global.body = null
