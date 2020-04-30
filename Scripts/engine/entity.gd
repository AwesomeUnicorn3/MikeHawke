extends KinematicBody2D
# warning-ignore:unused_signal
signal on_death
signal Health_Change
var TYPE = "ENEMY"
var id
var state = DEFAULT
var array_direction = [dir.RIGHT, dir.LEFT, dir.UP, dir.DOWN, dir.LEFT_UP, dir.LEFT_DOWN, dir.RIGHT_UP, dir.RIGHT_DOWN]
var array_nd_state = [DEFAULT, IDLE]
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
var Exp = 0
var entity_name = ""


var knockback = 0
var movedir = Vector2(0,0)
var spritedir = "Down"
var knockdir = Vector2(0,0)
var invincible = false

enum {
	MOVE,
	ATTACK,
	DEFAULT
	IDLE,
}

func movement_loop():
	var motion
	if knockback == 0:
		motion = movedir.normalized() * CurrentSpeed
	else:
		motion = knockdir.normalized() * 225
	
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2(0,0))

func spritedir_loop():
	match TYPE:
		"ENEMY":
			match movedir:
				dir.LEFT:
					spritedir = "Left"
				dir.RIGHT:
					spritedir = "Right"
				dir.UP:
					spritedir = "Up"
				dir.DOWN:
					spritedir = "Down"
				#Wheh diagonal sprites are added, be sure to change the directions to "Left_Up, Left_Down" 
				dir.LEFT_UP:
					spritedir = "Up"
				dir.RIGHT_UP:
					spritedir = "Up"
				dir.LEFT_DOWN:
					spritedir = "Down"
				dir.RIGHT_DOWN:
					spritedir = "Down"


func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func state_machine():
	match state:
		IDLE:
			anim_switch("Idle")
			spritedir_loop()
			movement_loop()

		DEFAULT:
				anim_switch("Walk")
				spritedir_loop()
				movement_loop()

		ATTACK:
			spritedir_loop()




func choose(array):
	randomize()
	array.shuffle()
	return array.front()



#func use_item(item):
#	var newitem = item.instance()
#	newitem.add_to_group(str(newitem.get_name(), self))
#	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
#		newitem.queue_free()
#	else:
#		add_child(newitem)
	

func player_blink():
	var Player
	while invincible == true:
		var modwhite = Color(1,1,1)
		var modred = Color(255,0,0,255)

		if get_node_or_null("Sprite/Body") == null:
			Player = $Sprite
		else:
			Player = $Sprite/Body
			
		Player.set_self_modulate(modred)
		$ModulateTimer.start()
		yield($ModulateTimer, "timeout")
		Player.set_self_modulate(modwhite)
		$ModulateTimer.start()
		yield($ModulateTimer, "timeout")

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
		InvicibleTimer.start(.3)
		match TYPE:
			"ENEMY":
				var def = ImportData.enemy_stats[$".".id]["CurrentDefense"]
				damage = (DAMAGE - def)
				ImportData.enemy_stats[$".".id]["CurrentHealth"] -= damage

		emit_signal("Health_Change")
		yield(InvicibleTimer, "timeout")
		invincible = false
		InvicibleTimer.queue_free()
		emit_signal("on_death")

