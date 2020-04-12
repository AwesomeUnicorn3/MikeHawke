extends "res://Scripts/engine/entity.gd"

export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
onready var hide_scene = preload("res://Scenes/Items/squirrel_pelt.tscn")


var dict = ImportData.enemy_stats as Dictionary
var dict_initial = ImportData.enemy_data as Dictionary
var pos = Vector2()
var selected = false
var talking = false
var interacting = false
var me
var DAMAGE = 0
var hide_
#var direction = dir.RIGHT
var array_timer = [.25, 2.3, 1.5, .75, 1, .5, 1.75]
var canmove = true


func _ready():
# warning-ignore:return_value_discarded
	self.connect("on_death", self, "on_death")
	movedir = Vector2(0,0)
	spritedir = "Down"
	TYPE = "ENEMY"
	me = self
	entity_name = "Squirrel" #name that is on the enemy data table
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
		var dict_2 = Global.Dict_objects_fruitville
		pos = Vector2(int(dict_2[id + "_Drop" ]["positionx"]), int(dict_2[id + "_Drop" ]["positiony"]))
		self.global_position = pos
		spawn_drop()
		call_deferred("death_deferred")
		
		
# warning-ignore:unused_argument
func _process(delta):
		DAMAGE = CurrentAttack
		state_machine()
		damage_loop()
		CurrentHealth = dict[id]["CurrentHealth"]
#		var health = dict[id]["CurrentHealth"]



func on_death():
	if CurrentHealth <= 0:
		Global.ExpDrop = Global.ExpDrop + ExpDrop
		spawn_drop()

		call_deferred("death_deferred")

func death_deferred():
	queue_free()
	
	

func _on_Timer_timeout():
	movedir = choose(array_direction)
	$Timer.wait_time = choose(array_timer)
	state = choose(array_nd_state)
	$Timer.start()


func spawn_drop():
	hide_ = hide_scene.instance()
	pos = self.global_position
	hide_.name = self.name + "_Drop" 
	call_deferred("spawn_obj_deferred")


func spawn_obj_deferred():
	$"../..".add_child(hide_)
	hide_.global_position = pos
