extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var CanRattle
var Select
var Flush

func _ready():
		CanRattle = load("res://Audio/SoundEffects/tm2_can000.wav")
		Select = load("res://Audio/SoundEffects/click_01.wav")
		Flush = load("res://Audio/SoundEffects/DhoodToiletFlush.wav")
# Called when the node enters the scene tree for the first time.
func can_rattle():
	var se = AudioStreamPlayer.new()
	self.add_child(se)
	se.set_stream(CanRattle)
	se.set_bus("SFX")
	se.play()
	yield(se, "finished")
	se.queue_free()

func select():
	var se = AudioStreamPlayer.new()
	self.add_child(se)
	se.set_stream(Select)
	se.set_bus("SFX")
	se.play()
	yield(se, "finished")
	se.queue_free()

func flush():
	var se = AudioStreamPlayer.new()
	self.add_child(se)
	se.set_stream(Flush)
	se.set_bus("SFX")
	se.play()
	yield(se, "finished")
	se.queue_free()
	
	
func _on_Button_pressed():
	flush()
	
