extends HBoxContainer

signal get_item_info(name)
signal drop_selected(count, itemdrop, item_price, cost, shopcount)
signal equip_item(itemdrop)

var dict_item = ImportData.item_data
var dict_char = ImportData.character_stats
var itemdrop
var count
var shopcount 
var item_price 
var cost : int
var type


func _ready():
	itemdrop = $ItemName.get_text()
	count = $ItemBackground/ItemButton/Label.get_text()
	shopcount = $ItemNumber.get_text()
	item_price = dict_item[itemdrop]["Sell Value"]
	cost = dict_item[itemdrop]["Cost"]
	type = dict_item[itemdrop]["Type"]

	match type:
		"Weapons":
			$UseItem.visible = false
			$Equip.visible = true
			$Drop.visible = true

		"Consumable":
			var canuse = dict_item[itemdrop]["CanUse"]
			if canuse == "Yes" and Global.buysell == "":
				$UseItem.visible = true
				$Equip.visible = false
				$Drop.visible = true

			else:
				$Equip.visible = false
				$Drop.visible = true

		"Armor":
			$UseItem.visible = false
			$Equip.visible = true
			$Drop.visible = true

		"Shoes":
			$UseItem.visible = false
			$Equip.visible = true
			$Drop.visible = true
		"Quest Items":
			$UseItem.visible = false
			$Equip.visible = false
			if Global.buysell == "Buy":
				$Drop.visible = true
			else:
				$Drop.visible = false

func _on_DropButton_button_up():
	emit_signal("drop_selected", count, itemdrop, item_price, cost, shopcount)


func _on_ItemButton_button_up():
	var name = self.name
	emit_signal("get_item_info", name)
	$ItemBackground.set_texture(load("res://Icons/ItemIconBackground.png"))

func _on_EquipButton_button_up():
	itemdrop = $ItemName.get_text()
	emit_signal("equip_item", itemdrop)


func _on_ItemButton_button_down():
	$ItemBackground.set_texture(load("res://Icons/ItemIconBackgroundPressed.png"))
