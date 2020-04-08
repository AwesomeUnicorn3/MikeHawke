extends Node2D
var TYPE = null
var maxamount = 1
var touchdamage = true
var id = "Melee Weapon"
var DAMAGE = 0

#enum {
#	MOVE,
#	ATTACK,
#	DEFAULT
#	IDLE,
#}


# Called when the node enters the scene tree for the first time.
func _ready():

	var parentAttack = get_parent().get("CurrentAttack")
	DAMAGE = parentAttack
	TYPE = get_parent().TYPE
# warning-ignore:return_value_discarded
	$anim.connect("animation_finished", self, "destroy")
	$anim.play(str("Swing", get_parent().spritedir))

	get_parent().weaponamt += 1
	


# warning-ignore:unused_argument
func destroy(animation):
	get_parent().weaponamt -= 1
	get_parent().attack_anim_finished()
	queue_free()

func death():
	get_parent().death()
