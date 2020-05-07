extends Node
#onready var root: Viewport = get_node("..")

onready var inventory_menu: PackedScene = load("res://Scenes/UI/Inventory.tscn")
onready var sub_menu: PackedScene = load("res://Scenes/UI/SubMenu1.tscn")
onready var shop_menu: PackedScene = load("res://Scenes/UI/ShopProcessing.tscn")

var mike

func show_hide_gui(value):
#	var rooot = String(root.get_path())
	var scenepath = String(Global.current_scene.get_path())
	var gui = get_node(scenepath + "/CanvasLayer/GUI")
	gui.hide_gui(value)



func sell_menu():
	var scenepath = String(Global.current_scene.get_path())
	var gui = get_node(scenepath + "/CanvasLayer/GUI")
	Global.shop_name = "Frank's Sundries"
	var scene_instance = shop_menu.instance()
	gui.add_child(scene_instance)
	
func can_interact():
	Global.CanInteract = true
	
	
func can_walk():
	Global.PlayerCanMove = true

	
func cant_walk():
	Global.PlayerCanMove = false

func walkright(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("RunRight", 0, speed)


func walkleft(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("RunLeft", 0, speed)
	
func walkup(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("RunUp", 0, speed)
	
func walkdown(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("RunDown", 0, speed)
	
func idledown(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("IdleDown", 0, speed)
	
func idleright(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("IdleRight", 0, speed)
	
func idleup(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("IdleUp", 0, speed)

func idleleft(speed):
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("IdleLeft", 0, speed)

func fridge():
	if MSG.level_root().get_node("main/InteractableObjects/Fridge/Open").visible == true:
		MSG.level_root().get_node("main/InteractableObjects/Fridge/Closed").visible = true
		MSG.level_root().get_node("main/InteractableObjects/Fridge/Open").visible = false
	else:
		MSG.level_root().get_node("main/InteractableObjects/Fridge/Closed").visible = false
		MSG.level_root().get_node("main/InteractableObjects/Fridge/Open").visible = true

func seq1():

	mike = MSG.level_root().get_node("main/Mike Hawke")

	walkright(0.6)
	mike.get_node("AnimationPlayer2").play("Seq1Pt1", 0 , .75)
	yield(mike, "animation_complete")
	idleup(1)
	fridge()
	seq2()

func seq2():
	var interaction_script = "res://dialogues/Sequence2.json"
	MSG.start_dialogue(interaction_script, self)
	yield(MSG, "message_ended")
	walkdown(1)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt2")
	yield(mike, "animation_complete")
	seq3()
func seq3():
	walkdown(1)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt3")
	yield(mike, "animation_complete")
	idleright(2)
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("DigRight", 0, 1)
	var throw = load("res://Scenes/Particles/ThrowShizzoCans.tscn")
	var scene = throw.instance()
	var pos = Vector2(Global.PlayerX, Global.PlayerY)
	scene.set_global_position(pos)
	MSG.level_root().add_child(scene)
	yield(scene, "complete")
	seq4()
func seq4():
	var interaction_script = "res://dialogues/Sequence4.json"
	MSG.start_dialogue(interaction_script, self)
	yield(MSG, "message_ended")
	walkdown(1)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt4")
	yield(mike, "animation_complete")
	seq5()
func seq5():

	walkdown(1)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt5")
	yield(mike, "animation_complete")
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").play("DigRight", 0, 1)
	var throw = load("res://Scenes/Particles/ThrowShizzoCans.tscn")
	var scene = throw.instance()
	var pos = Vector2(Global.PlayerX, Global.PlayerY)
	scene.set_global_position(pos)
	MSG.level_root().add_child(scene)
	yield(scene, "complete")
	idledown(1.25)
	var interaction_script = "res://dialogues/Sequence5.json"
	MSG.start_dialogue(interaction_script, self)
	yield(MSG, "message_ended")
	seq6()
	
func seq6():
	walkleft(1.5)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt6")
	yield(mike, "animation_complete")
	seq7()

func seq7():
	walkup(2)
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt7")
	yield(mike, "animation_complete")
	idleup(1)
	MSG.level_root().get_node("main/InteractableObjects/SideTable/Wallet").visible = false
	var interaction_script = "res://dialogues/Sequence7.json"
	MSG.start_dialogue(interaction_script, self)
	yield(MSG, "message_ended")
	end_sequence1()

func end_sequence1():
	MSG.level_root().get_node("main/Mike Hawke/MikeHawke Skeleton/AnimationPlayer").stop()
	mike.get_node("AnimationTree").active = true
	Global.new_game = false
	show_hide_gui(false)
	Global.gui = true
	Dialogue.can_walk()
	Global.CanTalk = true
	Global.CanInteract = true
	

func dialogue(ID):
	var dia = ImportData.dialogue_data
	var opt = ImportData.options_stats
	var text = ""
	var lang = opt["Dialogue Language"]["Text"]  #change to options language
	text = dia[ID][lang]
	MSG.set_var("text", text)

