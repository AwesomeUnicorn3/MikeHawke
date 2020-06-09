extends Control
signal menu_closed


onready var charname = $FullMenu/Header/CharName
onready var curr_health_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/CurrHealth
onready var curr_defense_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/CurrDefense
onready var curr_attack_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/CurrAttack
onready var curr_speed_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/CurrSpeed
onready var max_health_label = $FullMenu/TabsContainer/StatSlots/RightVBox/MaxHealth
onready var max_defense_label = $FullMenu/TabsContainer/StatSlots/RightVBox/MaxDefense
onready var max_attack_label = $FullMenu/TabsContainer/StatSlots/RightVBox/MaxAttack
onready var max_speed_label = $FullMenu/TabsContainer/StatSlots/RightVBox/MaxSpeed
onready var char_level_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/CurrLevel
onready var total_exp_label = $FullMenu/TabsContainer/StatSlots/MiddleVBox/TotalExp
onready var exp_to_next_level_label = $FullMenu/TabsContainer/StatSlots/RightVBox/ExpToNextLevel


var stats
var dict_formation = ImportData.formation_stats
var dict_char_stats = ImportData.character_stats
var dict_level = ImportData.level_data
var dict_items = ImportData.item_data
var dict_options = ImportData.options_stats
var curr_health
var curr_defense
var curr_attack
var curr_speed
var max_health
var max_defense
var max_attack
var max_speed
var char_level
var total_exp
var exp_to_next_level
var CurrentDefense
var CurrentAttack
var CurrentSpeed

var char_name
var char_selected
var parent = "Stats"
func _ready():

	for n in range(dict_formation.size()):
		char_name = dict_formation.keys()[n]
		var char_form_num = int(dict_formation[char_name]["FormationNumber"])
		var char_in_party = dict_formation[char_name]["InParty"]
		match char_form_num:
			1:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char1/Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char1/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char1.visible = true
			2:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char2/Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char2/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char2.visible = true
			3:	
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char3/Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char3/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char3.visible = true
			4:
				if char_in_party == "Yes":
					$FullMenu/TabsContainer/CharacterPanel/Char4/Button.disabled = false
					$FullMenu/TabsContainer/CharacterPanel/Char4/Label.set_text(char_name)
					$FullMenu/TabsContainer/CharacterPanel/Char4.visible = true
	_on_Char1_button_up()
	get_node("FullMenu/TabsContainer/CharacterPanel/Char1/Button").grab_focus()
	
func _on_ExitButton_button_up():
	emit_signal("menu_closed")
	queue_free()



func _on_Char1_button_up():
	char_selected = "Char1"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char1/Label.get_text()
	equip_adjustment()
	apply_char_stats()

func _on_Char2_button_up():
	char_selected = "Char2"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char2/Label.get_text()
	equip_adjustment()
	apply_char_stats()


func _on_Char3_button_up():
	char_selected = "Char3"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char3/Label.get_text()
	equip_adjustment()
	apply_char_stats()



func _on_Char4_button_up():
	char_selected = "Char4"
	char_name = $FullMenu/TabsContainer/CharacterPanel/Char4/Label.get_text()
	equip_adjustment()
	apply_char_stats()

func apply_char_stats():
	charname.set_text(char_name)
	
	curr_health = str(dict_char_stats[char_name]["CurrentHealth"])
	curr_health_label.set_text(curr_health)
	max_health = str(dict_char_stats[char_name]["MaxHealth"])
	max_health_label.set_text(max_health)
	
	CurrentAttack += dict_char_stats[char_name]["CurrentAttack"]
	curr_attack = str(dict_char_stats[char_name]["CurrentAttack"])
	curr_attack_label.set_text(str(CurrentAttack))
	max_attack = str(dict_char_stats[char_name]["MaxAttack"])
	max_attack_label.set_text(max_attack)
	
	CurrentDefense += dict_char_stats[char_name]["CurrentDefense"]
	curr_defense= str(dict_char_stats[char_name]["CurrentDefense"])
	curr_defense_label.set_text(str(CurrentDefense))
	max_defense = str(dict_char_stats[char_name]["MaxDefense"])
	max_defense_label.set_text(max_defense)

	CurrentSpeed += dict_char_stats[char_name]["CurrentSpeed"]
	curr_speed= str(dict_char_stats[char_name]["CurrentSpeed"])
	curr_speed_label.set_text(str(CurrentSpeed))
	max_speed = str(dict_char_stats[char_name]["MaxSpeed"])
	max_speed_label.set_text(max_speed)

	char_level= str(dict_char_stats[char_name]["Level"])
	char_level_label.set_text(char_level)

	total_exp = str(dict_char_stats[char_name]["Exp"])
	total_exp_label.set_text(total_exp)

	var next_level = str(int(char_level) + 1)
	exp_to_next_level = str(dict_level[next_level]["Exp"])
	exp_to_next_level_label.set_text(exp_to_next_level)


func equip_adjustment():
	CurrentDefense = 0
	CurrentSpeed = 0
	CurrentAttack = 0
	
#	var shoes = dict_char_stats[char_name]["ShoesEquipped"]
	var armor = dict_options[char_name + " defense"]["equipped_item"]
	var weapon = dict_options[char_name + " weapon"]["equipped_item"]
	
#	if shoes != null:
#		var shoe_speed = dict_items[shoes]["Speed"]
#		var shoe_attack = dict_items[shoes]["Attack"]
#		var shoe_def = dict_items[shoes]["Defense"]
#		CurrentSpeed += shoe_speed
#		CurrentAttack += shoe_attack
#		CurrentDefense += shoe_def
	
	if armor != null and armor != "Empty":
		var armor_speed = dict_items[armor]["Speed"]
		var armor_attack = dict_items[armor]["Attack"]
		var armor_def = dict_items[armor]["Defense"]
		CurrentSpeed += armor_speed
		CurrentAttack += armor_attack
		CurrentDefense += armor_def

	if weapon != null and weapon != "Empty":
		var weapon_speed = dict_items[weapon]["Speed"]
		var weapon_attack = dict_items[weapon]["Attack"]
		var weapon_def = dict_items[weapon]["Defense"]
		CurrentSpeed += weapon_speed
		CurrentAttack += weapon_attack
		CurrentDefense += weapon_def
