extends Control
signal menu_closed
onready var QuestItem : PackedScene = load("res://Scenes/UI/QuestNameHbox.tscn")
onready var QuestItem_Objective : PackedScene = load("res://Scenes/UI/QuestNameHbox_Objectives.tscn")
onready var quest_name = $FullMenu/TabsContainer/QuestDetailsBkg/QuestDetails/QuestName
onready var quest_list_container = $FullMenu/TabsContainer/QuestSelectionBkg/QuestSelection/QuestListScroll/VBoxContainer
onready var quest_description = $FullMenu/TabsContainer/QuestDetailsBkg/QuestDetails/DetailsScrollCont/Quest_Detail_Cont
onready var main_quest_button = get_node("FullMenu/TabsContainer/OptionsPanel/Main Quests/Button")
onready var side_quest_button = get_node("FullMenu/TabsContainer/OptionsPanel/Side Quests/Button")
onready var active_button = $FullMenu/TabsContainer/QuestSelectionBkg/QuestSelection/ActiveCompleteHbox/Active/Button
onready var completed_button = $FullMenu/TabsContainer/QuestSelectionBkg/QuestSelection/ActiveCompleteHbox/Complete/Button
onready var quest_objective_container = $FullMenu/TabsContainer/QuestDetailsBkg/QuestDetails/ObjectivesScrollCont/VBoxContainer
var dict_char_stats = ImportData.character_stats
var dict_quest_stats = ImportData.quest_stats
var quest_complete_icon = load("res://Icons/QuestComplete.png")
var quest_not_complete_icon = load("res://Icons/QuestNotComplete.png")


var questname
var questtype = ""
var questcomplete
var questactive
var questdescription
var questobjective1
var questobjective1complete
var questobjective2
var questobjective2complete
var questobjective3
var questobjective3complete
var questobjective4
var questobjective4complete
var questpreq1
var questpreq2
var questpreq3
var questpreq4

var qid
var quest_active
var quest_complete
var quest_type

func _ready():
	Quest.update_quest_0()
	_on_MainQuests_button_up()
	get_node("FullMenu/TabsContainer/OptionsPanel/Main Quests/Button").grab_focus()
func clear_data():
	var parent = quest_list_container
	var parent2 = quest_objective_container
	
	for n in parent.get_children():
		parent.remove_child(n)
		n.queue_free()
		
	for n in parent2.get_children():
		parent2.remove_child(n)
		n.queue_free()
		
	quest_description.set_text("")
	quest_name.set_text("")


func clear_quest_data():
	var parent2 = quest_objective_container
	for n in parent2.get_children():
		parent2.remove_child(n)
		n.queue_free()
		
	quest_description.set_text("")
	quest_name.set_text("")

func _on_ExitButton_button_up():
	emit_signal("menu_closed")
	queue_free()


func _on_MainQuests_button_up():
	questtype = "Main"
	main_quest_button.disabled = true
	side_quest_button.disabled = false
	_on_Active_button_up()

func _on_SideQuests_button_up():
	questtype = "Side"
	main_quest_button.disabled = false
	side_quest_button.disabled = true
	_on_Active_button_up()

func _on_Active_button_up():
	clear_data()
	active_button.disabled = true
	completed_button.disabled = false
	questactive = true
	questcomplete = false
	populate_quest_list()
	
	
func _on_Complete_button_up():
	clear_data()
	active_button.disabled = false
	completed_button.disabled = true
	questcomplete = true
	questactive = false
	populate_quest_list()
	
	
func _on_quest_selected(id):
	clear_quest_data()
	questname = dict_quest_stats[id]["QuestName"]
	questdescription = dict_quest_stats[id]["Description"]
	qid = id
	quest_description.set_text(questdescription)
	quest_name.set_text(questname)
	populate_objective_list()


func populate_quest_list():
	var size = dict_quest_stats.size()
	for i in range(0, size):
		quest_type = dict_quest_stats[str(i)]["QuestType"]
		quest_active = dict_quest_stats[str(i)]["Active"]
		quest_complete = dict_quest_stats[str(i)]["Complete"]
		if quest_complete == questcomplete and quest_active == questactive and quest_type == questtype:
			var newscene = QuestItem.instance()
			questname = dict_quest_stats[str(i)]["QuestName"]
			newscene.set_name(str(i))
			newscene.connect("detail", self, "_on_quest_selected")
			newscene.get_node("QuestName").set_text(questname)
			if quest_complete == true:
				newscene.get_node("QuestNameHbox/CheckBox").set_texture(quest_complete_icon)
			quest_list_container.add_child(newscene)


func populate_objective_list():
	for i in range(1, 4):
			var newscene = QuestItem_Objective.instance()
			var objectivename = "Objective" + str(i)
			var objectivecomplete = objectivename + "Complete"
			var objective = dict_quest_stats[str(qid)][objectivename]
			if objective != null:
				newscene.get_node("QuestName2/QuestName").set_text(objective)
				quest_complete = dict_quest_stats[str(qid)][objectivecomplete]
				if quest_complete == true:
					newscene.get_node("CheckBox").set_texture(quest_complete_icon)
				quest_objective_container.add_child(newscene)
