extends "res://Scripts/engine/entity.gd"

export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE


var dict_npc_stats = ImportData.enemy_stats as Dictionary
var dict_initial = ImportData.enemy_data as Dictionary
var dict_quest = ImportData.quest_stats as Dictionary
var dict_inventory = ImportData.inven_data as Dictionary

var selected = false
var talking = false
var interacting = false
var me
var DAMAGE = 0
var a
var b
var c
var d
var dead
#var direction = dir.RIGHT
var array_timer = [.25, 2.3, 1.5, .75, 1, .5, 1.75]
var canmove = true
var quest1_complete = "quest1_complete"
var quest1_active = "quest1_active"
var interacted = "interacted"
var quest1_name = "quest1_name" 
var objective1 = "objective1"
var objective2 = "objective2"
var objective3 = "objective3"
var objective4 = "objective4"


func _ready():
	entity_name = "NPCHilda" #name that is on the enemy data table
	startup()
	movedir = Vector2(0,0)
	spritedir = "Down"
	TYPE = "NPC"
	me = self


	


func startup():
	id = get_name()
	if dict_npc_stats.has(id) == false:
		var enemydata_file = File.new()
		enemydata_file.open("res://Data/EnemyStats - Sheet1.json", File.READ)
		var enemydata_json = JSON.parse(enemydata_file.get_as_text())
		enemydata_file.close()
		dict_npc_stats[id] = enemydata_json.result[entity_name]

	MaxSpeed = dict_npc_stats[id]["MaxSpeed"]
	CurrentSpeed = dict_npc_stats[id]["CurrentSpeed"]
	MaxHealth = dict_npc_stats[id]["MaxHealth"]
	CurrentHealth = dict_npc_stats[id]["CurrentHealth"]
	MaxAttack = dict_npc_stats[id]["MaxAttack"]
	CurrentAttack = dict_npc_stats[id]["CurrentAttack"]
	MaxDefense = dict_npc_stats[id]["MaxDefense"]
	CurrentDefense = dict_npc_stats[id]["CurrentDefense"]
	ExpDrop = dict_npc_stats[id]["ExpDrop"]
	if CurrentHealth <= 0:
		queue_free()
	a = dict_npc_stats[id]["a"]
	b = dict_npc_stats[id]["b"]
	c = dict_npc_stats[id]["c"]
	d = dict_npc_stats[id]["d"]
	dead = dict_npc_stats[id]["Dead"]




# warning-ignore:unused_argument
func _process(delta):
	if self.talking == true:
		pass
	elif self.selected == true:
		talk()
	else:
		if canmove == true:
			state_machine()
		else:
			spritedir = "IdleDown"
			state_machine()



func talk():
	if Global.CanInteract == false:
		self.talking = false
		self.interacting = false
		self.selected = false
		
	else:
		self.talking = true
		Dialogue.cant_walk()
		MSG.start_dialogue(interaction_script, self)
		yield(MSG, "message_ended")
		set_var_from_dialogue()
		self.selected = false
		Global.CanTalk = true
		self.talking = false
		Global.body = null
		Dialogue.can_walk()
		


# warning-ignore:unused_argument
func _input(event):
	if me == Global.body:
		if Input.is_action_pressed("ui_select"):
			self.selected = true

	if Input.is_action_just_released("ui_select"):
		self.selected = false


func _on_Timer_timeout():
	$Timer.wait_time = choose(array_timer)
	state = choose(array_state)
	$Timer.start()



func _on_Area2D_body_entered(body):
	if body.get_name() == "Mike Hawke":
		canmove = false

# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	canmove = true


func set_var_from_dialogue():
	ImportData.enemy_stats[MSG.var("npc_name")]["Interacted"] = MSG.var(interacted)
	ImportData.quest_stats[MSG.var("quest1_name")]["Active"] = MSG.var(quest1_active)
	ImportData.quest_stats[MSG.var("quest1_name")]["Complete"] = MSG.var(quest1_complete)
	ImportData.quest_stats[MSG.var("quest1_name")]["Objective1Complete"] = MSG.var(objective1)
	ImportData.quest_stats[MSG.var("quest1_name")]["Objective2Complete"] = MSG.var(objective2)
	ImportData.quest_stats[MSG.var("quest1_name")]["Objective3Complete"] = MSG.var(objective3)
	ImportData.quest_stats[MSG.var("quest1_name")]["Objective4Complete"] = MSG.var(objective4)
	
	if not ImportData.inven_data.has("Cat Carrier"):
		dict_inventory["Cat Carrier"] = ["Cat Carrier", 0]
	if not ImportData.inven_data.has("Queef"):
			dict_inventory["Queef"] = ["Queef", 0]
	if not ImportData.inven_data.has(Global.currency):
			dict_inventory[Global.currency] = [Global.currency, 0]

	if MSG.var("queef_in_inventory") == false:
		dict_inventory["Queef"][1] = 0
	else:
		dict_inventory["Queef"][1] = 1
	if MSG.var("cat_carrier_in_inventory") == false:
		dict_inventory["Cat Carrier"][1] = 0
	else:
		dict_inventory["Cat Carrier"][1] = 1

	if dict_quest[MSG.var("quest1_name")]["Complete"] == true:
		dict_inventory[Global.currency][1] += dict_quest[MSG.var("quest1_name")]["Reward"]
		dict_quest[MSG.var("quest1_name")]["Reward"] = 0
		Quest.update_quest_0()

