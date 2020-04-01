extends "res://Scripts/engine/entity.gd"


signal interact

onready var close_menu = get_node("../../CanvasLayer/GUI/MainMenu/MenuOptions/VBoxOptions/CloseMenu")
#Dialogue Variables
export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
var dialogue_next_input = "dialogue_next"
onready var look = get_node("RayCast2D")
 



var dict_char_stats = ImportData.character_stats
var dict_initial = ImportData.character_data
var dict_items = ImportData.item_data

func _ready():
	
	TYPE = "PLAYER"
	entity_name = "Mike Hawke"
	movedir = dir.CENTER
	spritedir = Global.PlayerDir
	
	$anim.play(Global.PlayerAnim)
	close_menu.connect("menu_closed", self, "equip_stats")
	startup()


func startup():
	id = entity_name
	if dict_char_stats.has(id) == false:
		dict_char_stats[id] = dict_initial[entity_name]
	CurrentSpeed = dict_char_stats[id]["CurrentSpeed"]
	MaxSpeed = dict_char_stats[id]["MaxSpeed"]
	
	MaxHealth = dict_char_stats[id]["MaxHealth"]
	CurrentHealth = dict_char_stats[id]["CurrentHealth"]
	
	MaxDefense = dict_char_stats[id]["MaxDefense"]
	CurrentDefense = dict_char_stats[id]["CurrentDefense"]
	
	CurrentAttack = dict_char_stats[id]["CurrentAttack"]
	MaxAttack = dict_char_stats[id]["MaxAttack"]

	Exp = dict_char_stats[id]["Exp"]
	
	equip_stats()
	
func _physics_process(_delta):
#	equip_stats()
	
	if Global.PlayerCanMove == false:
		pass
	elif state == ATTACK:
		_state_attack()

	else:
		
		controls_loop()
		state_machine()
		raydir_loop()
		damage_loop()
		Global.PlayerDir = spritedir
		if movedir != dir.CENTER:
			state = DEFAULT
		else:
			state = IDLE
		
		Global.PlayerAnim = $anim.get_current_animation()
		
		if Input.is_action_just_pressed("A"):
			var weapon = dict_char_stats[entity_name]["WeaponsEquipped"]
			var weapon_scene = "res://Scenes/Weapons/" + weapon + ".tscn"
			if weapon != null:
				use_item(load(weapon_scene))


func _set_state(value):
	state = value
	
func _state_attack():
	anim_switch("Idle")
	state_machine()
	damage_loop()
	
	
# warning-ignore:unused_argument
func _process(delta):
	
	Global.PlayerX = self.global_position.x
	Global.PlayerY = self.global_position.y
	emit_signal("interact")
	if Global.ExpDrop > 0:
		Exp = 0
		Exp += Global.ExpDrop
		Global.ExpDrop = 0
		dict_char_stats[id]["Exp"] += Exp
#		print(Exp)
#		print(dict_char_stats[id]["Exp"])

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed(dialogue_next_input):
		MSG.next()




func controls_loop():
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

func raydir_loop():
	match movedir:
		dir.LEFT:
			look.rotation_degrees = 90

		dir.RIGHT:
			look.rotation_degrees = -90

		dir.UP:
			look.rotation_degrees = 180

		dir.DOWN:
			look.rotation_degrees = 0

		#Diagonal Movement when you get diagonal sprite, change Degrees
		dir.LEFT_UP:
			look.rotation_degrees = 180
		dir.RIGHT_UP:
			look.rotation_degrees = 180
		dir.LEFT_DOWN:
			look.rotation_degrees = 0
		dir.RIGHT_DOWN:
			look.rotation_degrees = 0


func _on_MikeHawke_interact():
	if look.is_colliding() == true:
		var collision = look.get_collider()
#		print(collision)
		if collision != null:
			if collision.get("me"):
				Global.body = collision
	else:
		Global.body = null


func equip_stats():
	CurrentDefense = dict_char_stats[entity_name]["CurrentDefense"]
	CurrentSpeed = dict_char_stats[entity_name]["CurrentSpeed"]
	CurrentAttack = dict_char_stats[entity_name]["CurrentAttack"]
	
	var shoes = dict_char_stats[entity_name]["ShoesEquipped"]
	var armor = dict_char_stats[entity_name]["ArmorEquipped"]
	var weapon = dict_char_stats[entity_name]["WeaponsEquipped"]
	
	
	if shoes != null:
		var shoe_speed = dict_items[shoes]["Speed"]
		var shoe_attack = dict_items[shoes]["Attack"]
		var shoe_def = dict_items[shoes]["Defense"]
		CurrentSpeed += shoe_speed
		CurrentAttack += shoe_attack
		CurrentDefense += shoe_def
	
	if armor != null:
		var armor_speed = dict_items[armor]["Speed"]
		var armor_attack = dict_items[armor]["Attack"]
		var armor_def = dict_items[armor]["Defense"]
		CurrentSpeed += armor_speed
		CurrentAttack += armor_attack
		CurrentDefense += armor_def

	if weapon != null:
		var weapon_speed = dict_items[weapon]["Speed"]
		var weapon_attack = dict_items[weapon]["Attack"]
		var weapon_def = dict_items[weapon]["Defense"]
		CurrentSpeed += weapon_speed
		CurrentAttack += weapon_attack
		CurrentDefense += weapon_def

func _on_characterBackTimer_timeout():
	Global.Can_walk()

func death():
	print("You Died")


