#Item Template
#!!!!DO NOT CHANGE ANYTHING BEFORE SAVING SCRIPT WITH ITEM NAME!!!!

extends StaticBody2D


export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
var id
var selected = false
var talking = false
var interacting = false
var me
var pos

#Variables TO CHANGE FOR EACH ITEM TYPE

var location = "fruitville"  #Set to the name of the map **must be all lower case
var dict = Global.Dict_objects_fruitville   #set this to the dict of the item
var item = "Squirrel Pelt" #Change if there is an item drop  **must match name in ItemTable - Sheet1.json (See Import script)
var dialogue_variable = "s_pelt" #change this to variable from dialogue script
var num_items_dropped = 1


#Functions TO CHANGE FOR EACH ITEM TYPE
func item_script():
	MSG.start_dialogue(interaction_script, self)

	if dict[id]["active"] != false:
		sound_effect()
		item_drops()
		dict[id]["active"] = false


func sound_effect():
	pass
#	SoundEffects.can_rattle() #change sound effect


func on_not_interacted_item_load(): #on load if item has *NOT* been interacted with by player
	pass

func on_interacted_item_load(): #on load if item has been interacted with by player
	if dict[id]["active"] == true:
		self.global_position.x = dict[id]["positionx"]
		self.global_position.y = dict[id]["positiony"] 
	else:
		self.queue_free()

func item_drops():
	if not ImportData.inven_data.has(item):
		ImportData.inven_data[item] = [item, 0]
#use if assigning the number of dropped items in the dialogue
#	ImportData.inven_data[item][1] += MSG.var(dialogue_variable) 


#use if assigning the number of dropped items in the script 
	ImportData.inven_data[item][1] += num_items_dropped

#END FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#the below functions should not be changed in most cases
func _ready():
	me = self
	id = self.get_name()
	pos = self.global_position
	var this_dict = {"id": id, "active":true, "positionx":pos.x, "positiony":pos.y}
	if dict.keys().has(id) == false:
		dict[id] = this_dict
		on_not_interacted_item_load()
	else:
		on_interacted_item_load()

# warning-ignore:unused_argument
func _process(delta):
	pos = self.global_position
	if self.talking == true:
		pass
	elif self.selected == true:
		talk()
	
	if dict[id]["positionx"] != pos.x or dict[id]["positiony"] != pos.y:
		dict[id]["positionx"] = pos.x
		dict[id]["positiony"] = pos.y
func talk():
	if Global.CanInteract == false:
		pass
	else:
		self.talking = true
		self.selected= false
		Global.CanInteract = false
		Global.PlayerCanMove = false
		item_script()
		#only use if you have dialogue
		yield(MSG, "message_ended")
		Global.CanInteract = true
		Global.body = null
		Global.CanTalk = true
		self.talking = false
		Global.PlayerCanMove = true
		on_interacted_item_load()

# warning-ignore:unused_argument
func _input(event):
	if me == Global.body:
		if Input.is_action_pressed("ui_select"):
			self.selected = true
	if Input.is_action_just_released("ui_select"):
		self.selected = false





# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	Global.body = null
