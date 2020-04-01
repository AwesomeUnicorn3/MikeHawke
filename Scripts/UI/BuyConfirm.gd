extends Control


# Declare member variables here. Examples:
# var a = 2
signal time
signal refresh_inventory
onready var InventoryMenu : PackedScene = load("res://Scenes/UI/ShopProcessing.tscn")
onready var buy_spinbox = $DropPanelContainer/MainNodes/SellAmount_Cont/SpinBox
var dict_player_inv = ImportData.inven_data
var dict_shop_data = ImportData.shop_inven
var total_cost = 0

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
	var shopname = Global.shop_name
	var itemcost = $ItemCost.get_text()
	var shopcount = $ShopCount.get_text()
	var itemcount = dict_shop_data[shopname][shopcount]
	var curr = int(dict_player_inv[Global.currency][1]) 
	var price = int($DropPanelContainer/MainNodes/SellAmount_Cont/Total_price_container/Total_Price/Total_Price_Display.get_text())

#	print (curr)
	if buy_spinbox.get_max() > itemcount:
		buy_spinbox.set_max(itemcount)
	if (curr - price) < 0:
		NSF()
		yield(self, "time")
		buy_spinbox.set_value(curr/int(itemcost))

	else:
		if not dict_player_inv.has(itemdrop):
			dict_player_inv[itemdrop] = [itemdrop, 0]
	
		dict_player_inv[itemdrop][1] += buy_spinbox.get_value()
		dict_shop_data[shopname][shopcount] -= buy_spinbox.get_value()
		
		if not dict_player_inv.has(Global.currency):
			dict_player_inv[Global.currency] = [Global.currency, 0]
	
		dict_player_inv[Global.currency][1] -= int(total_cost)
	
		buy_spinbox.set_max(dict_shop_data[shopname][shopcount])
		
		emit_signal("refresh_inventory")
		itemcount = dict_shop_data[shopname][shopcount]
	if itemcount == 0 :
		queue_free()





func _on_DropAllButton_button_up():
	
	itemdrop = $ItemName.get_text()
	var shopname = Global.shop_name
	var itemcost = $ItemCost.get_text()
	var shopcount = $ShopCount.get_text()
	var itemcount = dict_shop_data[shopname][shopcount]
	var curr = int(dict_player_inv[Global.currency][1]) 
#	var price = int($DropPanelContainer/MainNodes/SellAmount_Cont/Total_price_container/Total_Price/Total_Price_Display.get_text())
	buy_spinbox.set_max(itemcount)
	buy_spinbox.set_value(itemcount)

	if buy_spinbox.get_max() > curr/int(itemcost):
		buy_spinbox.set_max(curr/int(itemcost))
		buy_spinbox.set_value(curr/int(itemcost))

	if not dict_player_inv.has(itemdrop):
		dict_player_inv[itemdrop] = [itemdrop, 0]
	if not dict_player_inv.has(Global.currency):
		dict_player_inv[Global.currency] = [Global.currency, 0]


#	dict_player_inv[itemdrop][1] += buy_spinbox.get_value()
#	itemcount -= buy_spinbox.get_value()
#	print(buy_spinbox.get_value())
#	dict_player_inv[Global.currency][1] -= int(total_cost)
#	yield(self, "time")
#	emit_signal("refresh_inventory")
#	self.queue_free()

# warning-ignore:unused_argument
func _on_SpinBox_value_changed(value):
	var item_amount = int(buy_spinbox.get_value())
	var price = int($DropPanelContainer/MainNodes/SellAmount_Cont/item_price_cont/item_price.get_text())
	total_cost = item_amount * price
	$DropPanelContainer/MainNodes/SellAmount_Cont/Total_price_container/Total_Price/Total_Price_Display.set_text(str(total_cost))
	emit_signal("time")


func NSF():
		var label = $NSFColorRect
		var labeltext = $NSFColorRect/NSFText
		var text1 = "You do not have enough "
		var id = String(Global.currency)
		var text2 = " to purchase selected amount of item"
		var save_text = text1 + id + text2
		labeltext.set_text(save_text)
		label.visible = true
		var t = Timer.new()
		t.set_one_shot(true)
		self.add_child(t)
		t.set_wait_time(2)
		t.start()
		yield(t, "timeout")
		
		label.visible = false
		emit_signal("time")
		t.queue_free()
