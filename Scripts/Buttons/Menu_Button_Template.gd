extends CanvasItem
signal menu_closed
onready var show =  false setget set_show_menu



export var scene = ""
export var Sfx = "Select"
export var sfx_volume = 1
var scene_node
var sub_menu
var menu
var new_scene
var btn_name

func _ready():
	
	$Label.set_text($".".get_name())
	btn_name = str($".".get_name())
	match btn_name:
		"New Game":
			set_focus()
		"Return":
			set_focus()
#		"Inventory":
#			set_focus()
#		"Weapons":
#			set_focus()

	if btn_name.left(4) == "File":
		btn_name = "Load"


func _on_TextureRect_button_up():
	btn_name = str($".".get_name())
	if btn_name.left(4) == "File":
		btn_name = "Load"
	var sound = SoundEffects.get(Sfx)

	SoundEffects.play_sfx(sound, sfx_volume)
	
	match btn_name:
		"New Game":
			Save_Game.new_game()
			Save_Game.save_game()
			Global.setScene(scene)

		"Load Game":
			Save_Game.load_game()
			Global.setScene(scene)

		"Quit Game":
			get_tree().quit()

		"Return":
			Global.setScene(scene)

		"Load":
			var id = str(get_node("../Filename").get_text())
			Global.load_path = String("res://Save/" + id)
			print(Global.load_path)
			Save_Game.load_game()
			Global.load_game = true
			Global.setScene(Global.load_scene)
			Global.game_loaded = true
			ImportData.inven_data = Global.dict_player_inventory
			ImportData.shop_inven = Global.dict_shop_inventory
			ImportData.enemy_stats = Global.dict_enemy_stats
			ImportData.character_stats = Global.dict_character_stats
			ImportData.formation_data = Global.dict_formation_stats
			ImportData.quest_stats = Global.dict_quest_stats
			ImportData.options_stats = Global.dict_options_stats
			ImportData.update_key_bindings()

		"Delete":
			var id = str(get_node("../../VBoxContainer2/Filename").get_text())
			Global.load_path = String("res://Save/" + id)
			var dir = Directory.new()
			dir.remove(Global.load_path)
			Global.setScene("res://Scenes/UI/LoadGame.tscn")

		"Inventory":
			var t = get_node("..")
			t.visible = false
			load_menu()
		"Equipment":
			var t = get_node("..")
			t.visible = false
			load_menu()
		"Status":
			var t = get_node("..")
			t.visible = false
			load_menu()
		"Quests":
			var t = get_node("..")
			t.visible = false
			load_menu()

		"Save":
			$Button.disabled = true
			Save_Game.save_game()
			var text1 = $Label2.get_text()
			var id = String(Global.save_id)
			var save_text = String("File ") + id + text1
			$Label2.set_text(save_text)
			$Label2.visible = true
			
			var t = Timer.new()
			t.set_one_shot(true)
			self.add_child(t)
			t.set_wait_time(2)
			t.start()
			yield(t, "timeout")
			
			$Label2.visible = false
			$Label2.set_text(" Save Complete")
			$Button.disabled = false
			t.queue_free()

		"Options":
			var t = get_node("..")
			t.visible = false
			load_menu()
		"Quit":
			get_tree().paused = false
			Global.setScene(scene)

		"Close Menu":
			var pause_button = get_node("../../../../TopLeftGui/PauseButton")
			Global.equip_menu_type = "GUI"
			Global.refresh_gui()
			pause_button.set_paused(false)
			emit_signal("menu_closed")
	
		"Weapons":
			var p = get_node("../../../..")
			if p.name == "FullMenu":
				p = get_node("../../../../..")
			p._on_Weapons_button_up()
		"Armor":
			var p = get_node("../../../..")
			if p.name == "FullMenu":
				p = get_node("../../../../..")
			p._on_Armor_button_up()
		"Skills":
			var p = get_node("../../../..")
			p._on_Skills_button_up()
		"Consumable":
			var p = get_node("../../../..")
			if p.name == "FullMenu":
				p = get_node("../../../../..")
			p._on_Consumable_button_up()
		"Quest Items":
			var p = get_node("../../../..")
			if p.name == "FullMenu":
				p = get_node("../../../../..")
			p._on_Quest_Items_button_up()

		"Exit":
			var p = get_node("../../..")
			match p.parent:
				"Shop":
					p._on_ExitButton_button_up()
				
				"Inventory":
					var t = get_node("../../../../../MenuOptions/VBoxOptions")
					var u = get_node("../../../../../MenuOptions/VBoxOptions/Inventory/Button")
					t.visible = true
					p._on_ExitButton_button_up()
					u.grab_focus()
				"EquipMenu":
					var t = get_node("../../../../../MenuOptions/VBoxOptions")
					var u = get_node("../../../../../MenuOptions/VBoxOptions/Inventory/Button")
					t.visible = true
					p._on_ExitButton_button_up()
					u.grab_focus()
				"Stats":
					var t = get_node("../../../../../MenuOptions/VBoxOptions")
					var u = get_node("../../../../../MenuOptions/VBoxOptions/Inventory/Button")
					t.visible = true
					p._on_ExitButton_button_up()
					u.grab_focus()
				"Quest Items":
					var t = get_node("../../../../../MenuOptions/VBoxOptions")
					var u = get_node("../../../../../MenuOptions/VBoxOptions/Inventory/Button")
					t.visible = true
					p._on_ExitButton_button_up()
					u.grab_focus()
				"Options":
					var t = get_node("../../../../../MenuOptions/VBoxOptions")
					var u = get_node("../../../../../MenuOptions/VBoxOptions/Inventory/Button")
					t.visible = true
					p._on_ExitButton_button_up()
					u.grab_focus()
		"Char1":
			
			var p = get_node("../../../..")
			if p.parent == "CharPanel":
				var t = $Label.get_text()
				p._on_char_selected(t)
			else:
				p._on_Char1_button_up()
#			set_focus()
		"Char2":
			var p = get_node("../../../..")
			if p.name == "CharPanel":
				p._on_char_selected($Label.get_text())
			else:
				p._on_Char2_button_up()
		"Char3":
			var p = get_node("../../../..")
			if p.name == "CharPanel":
				p._on_char_selected($Label.get_text())
			else:
				p._on_Char3_button_up()
		"Char4":
			var p = get_node("../../../..")
			if p.name == "CharPanel":
				p._on_char_selected($Label.get_text())
			else:
				p._on_Char2_button_up()
		"Slot1":
			var p = get_node("../../../..")
			p._on_char_selected($Label.get_text())
		"Slot2":
			var p = get_node("../../../..")
			p._on_char_selected($Label.get_text())
		"Slot3":
			var p = get_node("../../../..")
			p._on_char_selected($Label.get_text())
		"Slot4":
			var p = get_node("../../../..")
			p._on_char_selected($Label.get_text())

		"Swap":
			var p = get_node("../../../../../..")
			p._on_swapButton_button_up()
		"Unequip":
			var p = get_node("../../../../../..")
			p._on_unequpButton_button_up()

		"Main Quests":
			var p = get_node("../../../..")
			p._on_MainQuests_button_up()
		"Side Quests":
			var p = get_node("../../../..")
			p._on_SideQuests_button_up()
		"Active":
			var p = get_node("../../../../../..")
			p._on_Active_button_up()
		"Complete":
			var p = get_node("../../../../../..")
			p._on_Complete_button_up()
		
		"Controls":
			var p = get_node("../../../..")
			p._on_Controls_button_up()
			set_focus()

		"Drop":
			var p = get_node("../..")
			p._on_DropButton_button_up()
		"Equip":
			var p = get_node("../..")
			p._on_EquipButton_button_up()
		"Use Item":
			var p = get_node("../..")
			p._on_Use_ItemButton_button_up()

		"Close":
			var p = get_node("../../../..")
			p._on_Close_button_up()

		"Buy":
			var p = get_node("../..")
			var n = p.get_name()
			if n == "FullMenu":
				p = get_node("../../..")
				p._on_Buy_button_up()
			else:
				p._on_DropButton_button_up()

		"Sell":
			var p = get_node("../..")
			var n = p.get_name()
			if n == "FullMenu":
				p = get_node("../../..")
				p._on_Sell_button_up()
			else:
				p._on_DropButton_button_up()
			
		"Buy Selected":
			var p = get_node("../../../..")
			p._on_DropCustomButton_button_up()
		"Set Max":
			var p = get_node("../../../..")
			p._on_DropAllButton_button_up()

		"Sell All":
			var p = get_node("../../../..")
			p._on_DropAllButton_button_up()
		"Sell Selected":
			var p = get_node("../../../..")
			p._on_DropCustomButton_button_up()
			
		"Drop All":
			var p = get_node("../../../..")
			p._on_DropAll_button_up()
		"Drop Selected":
			var p = get_node("../../../..")
			p._on_DropCustomButton_button_up()

func set_show_menu(value: bool) -> void:
	show = value
	if value == true:
		sub_menu.visible = true
		var scene_instance = scene_node.instance()
		sub_menu.add_child(scene_instance)
		new_scene = scene_instance
		yield(new_scene, "menu_closed")
		sub_menu.visible = false
		show = false

	
func _on_Button_focus_entered():
	focus(true)


func _on_Button_focus_exited():
	focus(false)


func _on_Button_mouse_entered():
	get_node("Button").grab_focus()
	focus(true)


func _on_Button_mouse_exited():
	focus(false)


func focus(on_off):
	match on_off:
		true:
			$Particles2D.play("Focused")
		false:
			$Particles2D.stop()
			$Button.set_modulate(Color(1,1,1,1))
	
func set_focus():
	get_node("Button").grab_focus()

func load_menu():
		scene_node = load(scene)
		sub_menu = MSG.level_root().get_node("CanvasLayer/GUI/MainMenu/SubMenu1")
		set_show_menu(not show)

