extends Control


# Declare member variables here. Examples:
# var a = 
signal refresh_inventory
onready var InventoryMenu : PackedScene = load("res://Scenes/UI/InventoryMenu.tscn")
var dict_inv = ImportData.inven_data
var itemdrop
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("DropPanelContainer/MainNodes/Buttons/Drop All/Button").grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
	get_node("../FullMenu").visible = true
	get_node("../FullMenu/TabsContainer/CategoryPanel/Weapons/Button").grab_focus()
	self.queue_free()



func _on_DropCustomButton_button_up():
	itemdrop = $ItemName.get_text()
	dict_inv[itemdrop][1] -= $DropPanelContainer/MainNodes/SpinBox.get_value()
	$DropPanelContainer/MainNodes/SpinBox.set_max(dict_inv[itemdrop][1])
	emit_signal("refresh_inventory")


func _on_DropAll_button_up():
	itemdrop = $ItemName.get_text()
	dict_inv[itemdrop][1] -= dict_inv[itemdrop][1]
#	print(dict_inv[itemdrop][1])
	$DropPanelContainer/MainNodes/SpinBox.set_max(dict_inv[itemdrop][1])
	emit_signal("refresh_inventory")
	_on_Close_button_up()
