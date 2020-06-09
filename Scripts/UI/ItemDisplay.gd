extends Control

signal get_item_info(name)
signal drop_selected(count, itemdrop, item_price, cost, shopcount)
signal equip_item(itemdrop)

onready var use_item = get_node("ItemDisplay/Use Item")
onready var drop_item = get_node("ItemDisplay/Drop")
onready var equip_item = get_node("ItemDisplay/Equip")
onready var buy_item = get_node("ItemDisplay/Buy")
onready var sell_item = get_node("ItemDisplay/Sell")

var dict_item = ImportData.item_data
var dict_char = ImportData.character_stats
var itemdrop
var count
var shopcount 
var item_price 
var cost : int
var type
var parent
var buy_sell


func _ready():
	itemdrop = $ItemDisplay/ItemName.get_text()
	count = $ItemDisplay/ItemBackground/ItemButton/Label.get_text()
	shopcount = $ItemDisplay/ItemNumber.get_text()
	item_price = dict_item[itemdrop]["Sell Value"]
	cost = dict_item[itemdrop]["Cost"]
	type = dict_item[itemdrop]["Type"]

	match type:
		"Weapons":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				"Inventory":
					equip_item.visible = true
					drop_item.visible = true
		"Armor":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				"Inventory":
					equip_item.visible = true
					drop_item.visible = true
		"Consumable":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				
				"Inventory":
					var canuse = dict_item[itemdrop]["CanUse"]
					var canequip = dict_item[itemdrop]["CanEquip"]
					if canuse == "Yes":
						use_item.visible = true
					if canequip == "Yes":
						equip_item.visible = true
					drop_item.visible = true



		"skill":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				"Inventory":
					equip_item.visible = true
					drop_item.visible = true

		"defense":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				"Inventory":
					equip_item.visible = true
					drop_item.visible = true

		"Quest Items":
			match parent:
				"Shop":
					get_node("ItemDisplay/" + buy_sell).visible = true
				"Inventory":
					pass

func _on_DropButton_button_up():
	emit_signal("drop_selected", count, itemdrop, item_price, cost, shopcount)


func _on_ItemButton_button_up():
	var name = self.name
	emit_signal("get_item_info", name)
	$ColorRect.color = Color(0,0,0,0)
	
#	$ItemDisplay/ItemBackground.set_texture(load("res://Icons/ItemIconBackground.png"))

func _on_ItemButton_button_down():
	$AnimationPlayer.stop()
	$ColorRect.color = Color(0,0,0,1)
	
	
func _on_EquipButton_button_up():
	$ColorRect.color = Color(0,0,0,0)
	itemdrop = $ItemDisplay/ItemName.get_text()
	emit_signal("equip_item", itemdrop)

func _on_Use_ItemButton_button_up():
	pass

func _on_ItemButton_focus_entered():
	$AnimationPlayer.play("Item_Focus")


func _on_ItemButton_focus_exited():
	$AnimationPlayer.stop(true)
	$ColorRect.color = Color(0,0,0,0)


func _on_ItemButton_mouse_entered():
	_on_ItemButton_focus_entered()


func _on_ItemButton_mouse_exited():
	_on_ItemButton_focus_exited()
