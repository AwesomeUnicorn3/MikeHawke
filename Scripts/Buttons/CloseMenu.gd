extends CanvasItem

signal menu_closed
onready var pause_button: Button = get_node("../../../../TopLeftGui/PauseButton")

onready var inventory_button: Button = get_node("../InventoryButton")


func _on_TextureButton_button_up():
	Global.equip_menu_type = "GUI"
	Global.refresh_gui()
	SoundEffects.play_sfx(SoundEffects.Cancel, 5.0)
	if inventory_button.show == true:
		inventory_button._on_button_up()
	pause_button.set_paused(false)
	emit_signal("menu_closed")
