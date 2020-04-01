extends "res://Scripts/engine/entity.gd"

export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE


var dict = ImportData.enemy_stats as Dictionary
var dict_initial = ImportData.enemy_data as Dictionary


var selected = false
var talking = false
var interacting = false
var me
var DAMAGE = 0

#var direction = dir.RIGHT
var array_timer = [.25, 2.3, 1.5, .75, 1, .5, 1.75]
var canmove = true


func _ready():
	movedir = Vector2(0,0)
	spritedir = "Down"
	TYPE = "NPC"
	me = self
	entity_name = "NPCFrank" #name that is on the enemy data table
	startup()

func startup():
	id = get_name()
	if dict.has(id) == false:
		var enemydata_file = File.new()
		enemydata_file.open("res://Data/EnemyStats - Sheet1.json", File.READ)
		var enemydata_json = JSON.parse(enemydata_file.get_as_text())
		enemydata_file.close()
		dict[id] = enemydata_json.result[entity_name]

	MaxSpeed = dict[id]["MaxSpeed"]
	CurrentSpeed = dict[id]["CurrentSpeed"]
	MaxHealth = dict[id]["MaxHealth"]
	CurrentHealth = dict[id]["CurrentHealth"]
	MaxAttack = dict[id]["MaxAttack"]
	CurrentAttack = dict[id]["CurrentAttack"]
	MaxDefense = dict[id]["MaxDefense"]
	CurrentDefense = dict[id]["CurrentDefense"]
	ExpDrop = dict[id]["ExpDrop"]
	if CurrentHealth <= 0:
		queue_free()




# warning-ignore:unused_argument
func _process(delta):
	if self.talking == true:
		pass
	elif self.selected == true:
		talk()
	else:
		if canmove == true:
			pass
#			state_machine()



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
		self.selected = false
		Global.CanTalk = true
		self.talking = false
		Global.body = null
		


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
	if body.get_name() == "MikeHawke":
		canmove = false

# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	canmove = true
