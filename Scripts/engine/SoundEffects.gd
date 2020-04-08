extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var CanRattle
var Select
var Cancel
var Flush
var ExplosiveFart
var Squish
var Punch
var Slash

func _ready():
		CanRattle = load("res://Audio/SoundEffects/tm2_can000.wav")
		Select = load("res://Audio/SoundEffects/SFX_select1.wav")
		Cancel = load("res://Audio/SoundEffects/SFX_cancel2.wav")
		Flush = load("res://Audio/SoundEffects/DhoodToiletFlush.wav")
		ExplosiveFart = load("res://Audio/SoundEffects/SFX_fart2.wav")
		Squish = load("res://Audio/SoundEffects/SFX_squish1.wav")
		Punch = load("res://Audio/SoundEffects/SFX_punch1.wav")
		Slash = load("res://Audio/SoundEffects/SFX_swordslash1.wav")


func play_sfx(sfx, volume):
	var se = AudioStreamPlayer.new()
	self.add_child(se)
	se.set_stream(sfx)
	se.set_bus("SFX")
	se.set_volume_db(volume)
	se.play()
	yield(se, "finished")
	se.queue_free()


func _on_Button_button_up():
	 play_sfx(ExplosiveFart, 10.0)
