extends Node2D
var TYPE = null
var maxamount = 1
var touchdamage = true
var id = "Crappy Sword"
var DAMAGE = 0
enum {
	IDLE,
	ATTACK,
	DEFAULT
}


# Called when the node enters the scene tree for the first time.
func _ready():

	var parentAttack = get_parent().get("CurrentAttack")
	DAMAGE = parentAttack
	TYPE = get_parent().TYPE
# warning-ignore:return_value_discarded
	$anim.connect("animation_finished", self, "destroy")
	$anim.play(str("Swing", get_parent().spritedir))
	if get_parent().has_method("_state_attack"):
		get_parent()._set_state(ATTACK)


# warning-ignore:unused_argument
func destroy(animation):
	if get_parent().has_method("_state_attack"):
		get_parent().state = DEFAULT
	queue_free()

func death():
	get_parent().death()
