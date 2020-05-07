extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var velocityX = rand_range(-1350, 1350)
	var velocityY = rand_range(-750, 750)
	linear_velocity = Vector2(velocityX, velocityY)
	var t = Timer.new()
	var time = .75
	t.set_wait_time(time)
	add_child(t)
	t.one_shot = true
	t.start()
	yield(t, "timeout")
	$Shadow.visible = true

#	time = 15
#	t.set_wait_time(time)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()
#	queue_free()



func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
