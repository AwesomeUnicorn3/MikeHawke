extends KinematicBody2D
signal on_death
signal Health_Change
#signal interact
signal animation_complete

onready var close_menu = get_node("../../CanvasLayer/GUI/MainMenu/MenuOptions/VBoxOptions/Close Menu")
#Dialogue Variables
export (Texture) var face
export (Color) var color # COLOR OF THE TEXT
export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS
export (String, FILE) var interaction_script # A JSON DIALOGUE FILE
var dialogue_next_input = "dialogue_next"
onready var look = get_node("RayCast2D")
var weaponamt = 0
var wait = false
var TYPE
var entity_name
var movedir
var spritedir
var state
var id
var knockback = 0
var knockdir = Vector2(0,0)
var invincible = false
var drop_pos
var Delta
var acceleration = 1500
enum {
	MOVE,
	ATTACK,
	DEFAULT
	IDLE,
}
var array_state = [ DEFAULT, IDLE, ATTACK]
# stat variables
var MaxSpeed = 0
var CurrentSpeed = 0
var MaxHealth = 0
var CurrentHealth = 0
var MaxAttack = 0
var CurrentAttack = 0
var MaxDefense = 0
var CurrentDefense = 0
var ExpDrop = 0
var CurrExp = 0
var Exp = 0
var level = 0
#_____Variables for movement_____
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
#________________________________

#_____Variables for animation__________________________________________
#onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

#________________________________________________________________________

#_______Variables for weapon texture___________________________________
var weapon 
onready var weapon_file_format = "res://assets/weapons/%s.png"
onready var weapon_file = weapon_file_format % weapon
#________________________________________________________________


var dict_char_stats = ImportData.character_stats
var dict_initial = ImportData.character_data
var dict_items = ImportData.item_data
var dict_level = ImportData.level_data
func _ready():
	TYPE = "PLAYER"
	entity_name = "Mike Hawke"
	movedir = dir.CENTER
	spritedir = Global.PlayerDir
	state = MOVE
	
		#______Initializes animation__________
	animationState.start("Idle")
#	animationTree.active = true
	
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

	
	MaxHealth = dict_char_stats[id]["MaxHealth"]
	CurrentHealth = dict_char_stats[id]["CurrentHealth"]
	
	MaxDefense = dict_char_stats[id]["MaxDefense"]
	CurrentDefense = dict_char_stats[id]["CurrentDefense"]
	
	CurrentAttack = dict_char_stats[id]["CurrentAttack"]
	MaxAttack = dict_char_stats[id]["MaxAttack"]

	CurrExp = dict_char_stats[id]["Exp"]
	
	level = dict_char_stats[id]["Level"]
	equip_stats()

# warning-ignore:unused_argument
func _process(delta):
	Delta = delta
	if Global.PlayerCanMove == false:
		Global.PlayerX = global_position.x
		Global.PlayerY = global_position.y
	else:
#		emit_signal("interact")

		if Global.ExpDrop > 0:
			Exp = 0
			Exp += Global.ExpDrop
			Global.ExpDrop = 0
			dict_char_stats[id]["Exp"] += Exp
			CurrExp = dict_char_stats[id]["Exp"]
			var next_level = int(level) + 1
			var next_level_exp = dict_level[str(next_level)]["Exp"]
			level = int(level)
			if next_level_exp <= CurrExp:
				level_up()
		Global.PlayerX = global_position.x
		Global.PlayerY = global_position.y
		
	#______set machine state____

		match state:
			IDLE:
				animationState.travel("Idle")
				velocity = Vector2.ZERO 
			
			MOVE:
				move_state()
				Global.PlayerDir = spritedir
				
			ATTACK:
				attack_state()
		damage_loop()
		player_spritedir_loop()

# warning-ignore:unused_argument
func _input(event):
#______close program when "ui_cancel" is pressed______
	if Input.is_action_pressed("ui_cancel"):
		Global.setScene("res://Scenes/TitleScreen.tscn")

	if Input.is_action_just_pressed(dialogue_next_input):
		MSG.next()

	if Input.is_action_pressed("ui_select"):
		_on_MikeHawke_interact()

func player_spritedir_loop():
	input_vector.x = round(input_vector.x)
	input_vector.y = round(input_vector.y)
	match input_vector:
		dir.LEFT:
			spritedir = "Left"
			look.rotation_degrees = 45
			look.cast_to.y = 25
			drop_pos = Vector2(-45, 0)
		dir.RIGHT:
			spritedir = "Right"
			look.rotation_degrees = -45
			look.cast_to.y = 25
			drop_pos = Vector2(25, 0)
		dir.UP:
			spritedir = "Up"
			look.rotation_degrees = 180
			look.cast_to.y = 30
			drop_pos = Vector2(-10, -40)
		dir.DOWN:
			spritedir = "Down"
			look.rotation_degrees = 0
			look.cast_to.y = 40
			drop_pos = Vector2(-10, 25)
	#Wheh diagonal sprites are added, be sure to change the directions to "Left_Up, Left_Down" 
		dir.LEFT_UP:
			spritedir = "Up"
			look.rotation_degrees = 180
			look.cast_to.y = 30
			drop_pos = Vector2(-10, -40)
		dir.RIGHT_UP:
			spritedir = "Up"
			look.rotation_degrees = 180
			look.cast_to.y = 30
			drop_pos = Vector2(-10, -40)
		dir.LEFT_DOWN:
			spritedir = "Down"
			look.rotation_degrees = 0
			look.cast_to.y = 40
			drop_pos = Vector2(-10, 25)
		dir.RIGHT_DOWN:
			spritedir = "Down"
			look.rotation_degrees = 0
			look.cast_to.y = 40
			drop_pos = Vector2(-10, 25)
	Global.PlayerDir = spritedir


func _on_MikeHawke_interact():
	if look.is_colliding() == true and Global.carry == false:
		var collision = look.get_collider()
		if collision.get("me"):
			Global.body = collision
			state = IDLE
			animationState.travel("Idle")
			velocity = Vector2.ZERO 
			collision.interact()
			yield(MSG, "message_ended")
			state = MOVE
	else:
		Global.body = null
		if state == IDLE:
			state = MOVE

func equip_stats():
	var dict_options = ImportData.options_stats
	CurrentDefense = dict_char_stats[entity_name]["CurrentDefense"]
	CurrentSpeed = dict_char_stats[entity_name]["CurrentSpeed"]
	CurrentAttack = dict_char_stats[entity_name]["CurrentAttack"]

	var armor = dict_options[entity_name + " defense"]["equipped_item"]
	weapon = dict_options[entity_name + " weapon"]["equipped_item"]
	
	
	if armor != "Empty":
		var armor_speed = dict_items[armor]["Speed"]
		var armor_attack = dict_items[armor]["Attack"]
		var armor_def = dict_items[armor]["Defense"]
		CurrentSpeed += armor_speed
		CurrentAttack += armor_attack
		CurrentDefense += armor_def

	if weapon != "Empty":
		var weapon_speed = dict_items[weapon]["Speed"]
		var weapon_attack = dict_items[weapon]["Attack"]
		var weapon_def = dict_items[weapon]["Defense"]
		CurrentSpeed += weapon_speed
		CurrentAttack += weapon_attack
		CurrentDefense += weapon_def


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
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")


#__________________________________________________________________________________________________

	if input_vector != Vector2.ZERO: #if player is moving
	#___________________Get animation state_________________________________
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
	#________________________________________________________________________
		animationState.travel("Run")
		velocity = input_vector * CurrentSpeed 
		if velocity.length() > CurrentSpeed:
			velocity = velocity.normalized() * CurrentSpeed #move
	else: #if player is standing still
		apply_friction(acceleration * Delta)

#___________________ATTACK!!! ('A' key)_______________________
	if Input.is_action_just_pressed("ui_use_slot_weapon"):
		state = ATTACK
		
	if knockback == 0:
		pass
	else:
		velocity = knockdir.normalized() * 225
		state = MOVE
		
	velocity = move_and_slide(velocity) #starts player movement

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO #stopr

func attack_state():
	if wait == false:
#______Initializes weapon_______________
		weapon = ImportData.options_stats["Mike Hawke weapon"]["equipped_item"]
		var weapon_scene = "res://Scenes/Weapons/" + weapon + ".tscn"
		if weapon != null:
			animationState.travel("Attack")
			use_item(load(weapon_scene))
			wait = true
			$AttackTimer.start()

func use_item(item):
	var newitem = item.instance()
	newitem.add_to_group(str(newitem.get_name(), self))
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
	else:
		add_child(newitem)

func _on_KnockBackTimer_timeout():
	Global.Can_walk()


func _on_InvicibleTimer_timeout():
	invincible = false

func damage_loop():
	if knockback > 0:
		knockback -= 1
	
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if knockback == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			on_entity_hit(body.get("DAMAGE"))
			knockback = 10
			knockdir = global_transform.get_origin() - body.global_transform.get_origin()
#		print(body.name)

func on_entity_hit(DAMAGE):
	var damage = 0
	if invincible  == false:
		invincible = true
		player_blink()
		var InvicibleTimer = Timer.new()
		get_parent().add_child(InvicibleTimer)
		InvicibleTimer.start(.5)
		match TYPE:
			"ENEMY":
				var def = ImportData.enemy_stats[$".".id]["CurrentDefense"]
				damage = (DAMAGE - def)
				ImportData.enemy_stats[$".".id]["CurrentHealth"] -= damage

			"PLAYER":
				damage = DAMAGE - ImportData.character_stats[id]["CurrentDefense"]
				if damage <= 0:
					damage = 5
				ImportData.character_stats[id]["CurrentHealth"] -= damage

		emit_signal("Health_Change")
		yield(InvicibleTimer, "timeout")
		invincible = false
		InvicibleTimer.queue_free()
		emit_signal("on_death")

func player_blink():
	var Player = get_node("MikeHawke Skeleton")
	while invincible == true:
		var modwhite = Color(1,1,1)
		var modred = Color(255,0,0,255)
		Player.set_modulate(modred)
		$ModulateTimer.start()
		yield($ModulateTimer, "timeout")
		Player.set_modulate(modwhite)
		$ModulateTimer.start()
		yield($ModulateTimer, "timeout")

func _on_ModulateTimer_timeout():
	pass


func _on_AttackTimer_timeout():
	wait = false

func attack_anim_finished():
	state = MOVE

func set_scene(CamZoom):
	if Global.load_game == true:
		set_global_position(Vector2(Global.PlayerX, Global.PlayerY))
		$Camera2D.set_zoom(CamZoom)
		Global.load_game = false
	else:
		set_global_position(Vector2(Global.PlayerXTransfer, Global.PlayerYTransfer))


func anim_complete():
	emit_signal("animation_complete")

func level_up():
	var next_level = int(level) + 1
	var next_level_exp = dict_level[str(next_level)]["Exp"]
	var r = false
	while r == false:
		next_level = int(level) + 1
		next_level_exp = dict_level[str(next_level)]["Exp"]
		if next_level_exp <= CurrExp:
			dict_char_stats[name]["Level"] += 1
			level = dict_char_stats[name]["Level"]
			
			dict_char_stats[name]["CurrentAttack"] += int(dict_level[str(level)]["AttackMod"])
			dict_char_stats[name]["MaxAttack"] += int(dict_level[str(level)]["AttackMod"])
			dict_char_stats[name]["CurrentDefense"] += int(dict_level[str(level)]["DefenseMod"])
			dict_char_stats[name]["MaxDefense"] += int(dict_level[str(level)]["DefenseMod"])
			dict_char_stats[name]["CurrentHealth"] += int(dict_level[str(level)]["HealthMod"])
			dict_char_stats[name]["MaxHealth"] += int(dict_level[str(level)]["HealthMod"])
			emit_signal("Health_Change")
		else:
			r = true


