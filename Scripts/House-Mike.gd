extends Node2D

export (Texture) var face

export (Color) var color # COLOR OF THE TEXT

export (float, 0.1, 1.9) var voice_pitch # HOW HIGH / LOW THE VOICE IS

export (String, FILE) var interaction_script # A JSON DIALOGUE FILE

onready var mike = get_node("main/Mike Hawke")
onready var gui: Control = get_node("CanvasLayer/GUI")
export var Mikex = 0
export var Mikey = -62

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.new_game == true:
		begin_sequence1()
	else:
		mike.set_scene()
		Global.load_scene = self.filename
	
func begin_sequence1():
	gui.hide_gui(true)
	$MikeSleeping.visible = true
	Global.CanInteract = false
	mike.visible = false
	mike.set_global_position(Vector2(-133,-253))

	Global.PlayerCanMove = false

	sequence1Aa()
	
	
func sequence1Aa():
	
	var t = Timer.new()
	t.set_one_shot(true)
	self.add_child(t)
	t.set_wait_time(2)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = true
	
	t.set_wait_time(1)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = false
	
	t.set_wait_time(1)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = true
	
	t.set_wait_time(1)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = false
	
	t.set_wait_time(1)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = true
	
	t.set_wait_time(0.5)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = false
	
	t.set_wait_time(0.5)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = true
	
	t.set_wait_time(0.5)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = false
	
	t.set_wait_time(0.5)
	t.start()
	yield(t, "timeout")
	$MikeEyesOpen.visible = true
	
	t.queue_free()
	$MikeEyesOpen.visible = false
	$MikeSleeping.visible = false
	mike.visible = true

	MSG.start_dialogue(interaction_script, self)
	
#	gui.hide_gui(true)


