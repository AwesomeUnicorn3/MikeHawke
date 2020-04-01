extends Control


# Declare member variables here. Examples:
# var a = 
signal refresh_inventory
onready var InventoryMenu : PackedScene = load("res://Scenes/UI/InventoryMenu.tscn")
var dict_inv = ImportData.inven_data
var itemdrop
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
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
	self.queue_free()
