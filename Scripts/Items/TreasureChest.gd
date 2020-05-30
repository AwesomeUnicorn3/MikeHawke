#Item Template
#!!!!DO NOT CHANGE ANYTHING BEFORE SAVING SCRIPT WITH ITEM NAME!!!!



extends StaticBody2D
export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
onready var gui: Control = get_node("../../../../CanvasLayer")

var looted = false
var contents = {}
var GetLoot 
var dict = Global.Dict_loot #set this to the dict of the item
var array = {"Interacted": false}  
#var item = "Sticky Aluminum" #Change if there is an item drop
#var dialogue_variable = "cans" #change this to variable from dialogue script
var text = false
var full = "full"
var empty = "empty"
var loot = "loot"
var chest = full
var me
var id
var selected = false
var talking = false
var interacting = false
export var item1 = "Crappy Sword"
export var item2 = "T-Shirt"
export var item3 = "Hockey Drop"
export var item4 = "Moonshine"
export var item1count = 1
export var item2count = 1
export var item3count = 1
export var item4count = 1

#FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#change this for each item
func item_script():
#	MSG.start_dialogue(interaction_script, self)
#	sound_effect()
#	item_drops()
	
	if dict[id].has("Interacted") == false:
		if array["Interacted"] != true:
			on_not_interacted_item_load()
			array["Interacted"] = true
			array[loot] = GetLoot.loot_dict
			dict[id] = array
	else:
		
		if dict[id].has(loot) == true:
			dictloop()
#			if text == true:
#				pass
#			elif text == false:
#				pass
		else:
			chest = empty
		on_interacted_item_load()
	MSG.msg_ended()




#func item_drops():
#	Global.dict_items[item] += MSG.var(dialogue_variable) 

func sound_effect():
	SoundEffects.can_rattle() #change sound effect


func on_not_interacted_item_load(): #on load if item has *NOT* been interacted with by player
	loadscene()
	
	GetLoot.static_loot(item1, item1count)
	if item2 != "":
		GetLoot.static_loot(item2, item2count)
	if item3 != "":
		GetLoot.static_loot(item3, item3count)
	if item4 != "":
		GetLoot.static_loot(item4, item4count)


func on_interacted_item_load(): #on load if item has been interacted with by player
	loadscene()

	if chest == empty:
		pass
	else:
		GetLoot.loot_dict = dict[id][loot]
		if text == false:
			GetLoot.PopulatePanel()
		else:
			GetLoot.PopulatePanel_text()
	

	

#END FUNCTIONS TO CHANGE FOR EACH ITEM TYPE

#the below functions should not be changed in most cases
func _ready():
	me = self
	id = self.get_name()
	if dict.has(id) == false:
		dict[id] = {}



## warning-ignore:unused_argument
#func _process(delta):
#	if self.talking == true:
#		pass
#	elif self.selected == true:
#		talk()


func interact():
	if Global.CanInteract == false:
		pass
	else:
		self.talking = true
		self.selected= false
		Global.CanInteract = false
		Global.PlayerCanMove = false
		item_script()
		
		yield(GetLoot, "closed")
		dict[id][loot] = GetLoot.loot_dict
		Global.dict_player_inventory = ImportData.inven_data
		GetLoot.queue_free()
		Global.CanInteract = true
		Global.body = null
		Global.CanTalk = true
		self.talking = false
		Global.Can_walk()
		MSG.msg_ended()




	
# warning-ignore:unused_argument
func _input(event):
	if me == Global.body:
		if Input.is_action_pressed("ui_select"):
			self.selected = true
	if Input.is_action_just_released("ui_select"):
		self.selected = false

func loadscene():
	var scene = load("res://Scenes/UI/LootPanel.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name(id)
	gui.add_child(scene_instance)
	GetLoot = scene_instance



func dictloop():
	for i in dict[id][loot].keys():
		var type = typeof(i)
		if type == 4:
			ImportData.importtext = true
			text = true
		if type == 2:
			ImportData.importtext = false
# warning-ignore:standalone_expression
			text == false




# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	Global.body = null
