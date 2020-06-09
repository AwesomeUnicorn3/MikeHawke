extends Control


# Declare member variables here. Examples:
# var a = 2

signal refresh_inventory
onready var InventoryMenu : PackedScene = load("res://Scenes/UI/ShopProcessing.tscn")
var dict_player_inv = ImportData.inven_data
var dict_shop_data = ImportData.shop_inven
var total_cost = 0

var itemdrop
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("DropPanelContainer/MainNodes/Buttons/Sell All/Button").grab_focus()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
	get_node("../FullMenu").visible = true
	get_node("../FullMenu/TabsContainer/CategoryPanel/Weapons/Button").grab_focus()
	self.queue_free()



func _on_DropCustomButton_button_up():
	itemdrop = $ItemName.get_text()
#
	dict_player_inv[itemdrop][1] -= $DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox.get_value()

	if not dict_player_inv.has(Global.currency):
		dict_player_inv[Global.currency] = [Global.currency, 0]

	dict_player_inv[Global.currency][1] += int(total_cost)

	$DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox.set_max(dict_player_inv[itemdrop][1])
	emit_signal("refresh_inventory")





func _on_DropAllButton_button_up():
	itemdrop = $ItemName.get_text()
	if not dict_player_inv.has(Global.currency):
		dict_player_inv[Global.currency] = [Global.currency, 0]
	var item_amount = int(dict_player_inv[itemdrop][1])
	var price = int($DropPanelContainer/MainNodes/SellAmount_Cont/item_price_cont/item_price.get_text())
	itemdrop = $ItemName.get_text()
#	var value = dict_player_inv[itemdrop][1]
	total_cost = item_amount * price
	dict_player_inv[itemdrop][1] -= dict_player_inv[itemdrop][1]
	dict_player_inv[Global.currency][1] += int(total_cost)

	emit_signal("refresh_inventory")
	self.queue_free()

# warning-ignore:unused_argument
func _on_SpinBox_value_changed(value):
	var item_amount = int($DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox.get_value())
	var price = int($DropPanelContainer/MainNodes/SellAmount_Cont/item_price_cont/item_price.get_text())
	total_cost = item_amount * price
	$DropPanelContainer/MainNodes/SellAmount_Cont/Total_price_container/Total_Price/Total_Price_Display.set_text(str(total_cost))
	
