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
var weaponamt = 0
var wait = false

#_____Variables for movement_____
var speed = 75
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
#________________________________

#_____Variables for animation__________________________________________
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#________________________________________________________________________

#_______Variables for weapon texture___________________________________
var weapon = "Fist" 
onready var weapon_file_format = "res://assets/weapons/%s.png"
onready var weapon_file = weapon_file_format % weapon
#________________________________________________________________


var dict_char_stats = ImportData.character_stats
var dict_initial = ImportData.character_data
var dict_items = ImportData.item_data

func _ready():
	TYPE = "PLAYER"
	entity_name = "Mike Hawke"
	movedir = dir.CENTER
	spritedir = Global.PlayerDir
	state = MOVE
	
		#______Initializes animation__________
	animationState.start("Idle")
	animationTree.active = true
	
#	$AnimationPlayer.play(Global.PlayerAnim)
	close_menu.connect("menu_closed", self, "equip_stats")
# warning-ignore:return_value_discarded
	self.connect("on_death", self, "on_death")
	startup()


func startup():
	id = entity_name
	if dict_char_stats.has(id) == false:
		dict_char_stats[id] = dict_initial[entity_name]
	CurrentSpeed = dict_char_stats[id]["CurrentSpeed"]
	MaxSpeed = dict_char_stats[id]["MaxSpeed"]
	speed = CurrentSpeed
	
	MaxHealth = dict_char_stats[id]["MaxHealth"]
	CurrentHealth = dict_char_stats[id]["CurrentHealth"]
	
	MaxDefense = dict_char_stats[id]["MaxDefense"]
	CurrentDefense = dict_char_stats[id]["CurrentDefense"]
	
	CurrentAttack = dict_char_stats[id]["CurrentAttack"]
	MaxAttack = dict_char_stats[id]["MaxAttack"]

	Exp = dict_char_stats[id]["Exp"]
	equip_stats()

# warning-ignore:unused_argument
func _process(delta):
	if Global.PlayerCanMove == false:
		pass
	else:
		emit_signal("interact")
		if Global.ExpDrop > 0:
			Exp = 0
			Exp += Global.ExpDrop
			Global.ExpDrop = 0
			dict_char_stats[id]["Exp"] += Exp
		raydir_loop()
		Global.PlayerX = global_position.x
		Global.PlayerY = global_position.y
		
	#______set machine state____

		match state:
			MOVE:
				move_state()
				Global.PlayerDir = spritedir
			ATTACK:
				attack_state()
		damage_loop()

# warning-ignore:unused_argument
func _input(event):
#______close program when 'esc' is pressed______
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed(dialogue_next_input):
		MSG.next()
#func controls_loop():
	var UP = Input.is_action_pressed("move_up")
	var DOWN = Input.is_action_pressed("move_down")
	var LEFT = Input.is_action_pressed("move_left")
	var RIGHT = Input.is_action_pressed("move_right")
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	spritedir_loop()

func raydir_loop():
	match movedir:
		dir.LEFT:
			look.rotation_degrees = 90
			look.cast_to.y = 25
		dir.RIGHT:
			look.rotation_degrees = -90
			look.cast_to.y = 25
		dir.UP:
			look.rotation_degrees = 180
			look.cast_to.y = 30
		dir.DOWN:
			look.rotation_degrees = 0
			look.cast_to.y = 30

		#Diagonal Movement when you get diagonal sprite, change Degrees
		dir.LEFT_UP:
			look.rotation_degrees = 125
			look.cast_to.y = 25
		dir.RIGHT_UP:
			look.rotation_degrees = -125
			look.cast_to.y = 25
		dir.LEFT_DOWN:
			look.rotation_degrees = 45
			look.cast_to.y = 25
		dir.RIGHT_DOWN:
			look.rotation_degrees = -45
			look.cast_to.y = 25


func _on_MikeHawke_interact():
	if look.is_colliding() == true:
		var collision = look.get_collider()
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
	weapon = dict_char_stats[entity_name]["WeaponsEquipped"]
	
	
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

#func _on_characterBackTimer_timeout():
#	Global.Can_walk()

func on_death():
	var health = ImportData.character_stats[id]["CurrentHealth"]
	if health <= 0:
		print("You Died")
		call_deferred("death_deferred")

func death_deferred():
	Global.setScene("res://Scenes/TitleScreen.tscn")
	#Change scene to "You died" then navigate to main menu


func move_state(): #Character movement and animation
#_________Get input from player___________________________________________________________________
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
#__________________________________________________________________________________________________

	if input_vector != Vector2.ZERO: #if player is moving
	#___________________Get animation state_________________________________
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
	#________________________________________________________________________
		
		animationState.travel("Run")
		velocity = input_vector * speed #move
	else: #if player is standing still
		animationState.travel("Idle")
		velocity = Vector2.ZERO #stopr

	
#___________________ATTACK!!! ('A' key)_______________________
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
		
	if knockback == 0:
		pass
	else:
		velocity = knockdir.normalized() * 225
		state = MOVE
		
	velocity = .move_and_slide(velocity) #starts player movement

func attack_state():
#	animationState.travel("Attack")
	if wait == false:
#______Initializes weapon_______________
		weapon = dict_char_stats[entity_name]["WeaponsEquipped"]
		var weapon_scene = "res://Scenes/Weapons/" + weapon + ".tscn"
		if weapon != null:
			use_item(load(weapon_scene))
			wait = true
			$AttackTimer.start()



func attack_anim_finished():
	state = MOVE
#_______________________________________________________


func _on_KnockBackTimer_timeout():
	Global.Can_walk()


func _on_InvicibleTimer_timeout():
	invincible = false


func set_scene():
	if Global.load_game == true:
		Global.load_scene = get_node("../..").filename
		set_global_position(Vector2(Global.PlayerX, Global.PlayerY))
		animationTree.active = true
		Global.load_game = false

	else:
		Global.load_scene = get_node("../..").filename
		set_global_position(Vector2(Global.PlayerXTransfer, Global.PlayerYTransfer))
		animationTree.active = true


func _on_ModulateTimer_timeout():
	pass


func _on_AttackTimer_timeout():
	wait = false
