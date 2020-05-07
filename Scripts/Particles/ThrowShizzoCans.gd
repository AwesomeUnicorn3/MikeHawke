extends Node2D
onready var throw = load("res://Scenes/Items/ShizzoToThrow.tscn")
signal complete
# Called when the node enters the scene tree for the first time.
func _ready():
	var t = Timer.new()
	self.add_child(t)
	t.set_one_shot(true)
	
	for _i in range(1,8):
		var particle = throw.instance()
		add_child(particle)
		SoundEffects.play_sfx(SoundEffects.CanRattle, 1)
		randomize()
		var time = rand_range(0.2, 0.3)
		t.set_wait_time(time)
		t.start()
		yield(t, "timeout")
	emit_signal("complete")
#	t.set_wait_time(6)
#	t.start()
#	yield(t, "timeout")
	t.queue_free()

#	self.queue_free()
