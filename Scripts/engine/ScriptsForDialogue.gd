extends Node
#onready var root: Viewport = get_node("..")
onready var inventory_menu: PackedScene = load("res://Scenes/UI/Inventory.tscn")
onready var sub_menu: PackedScene = load("res://Scenes/UI/SubMenu1.tscn")
onready var shop_menu: PackedScene = load("res://Scenes/UI/ShopProcessing.tscn")
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
#	print("can_walk called")
	
func cant_walk():
	Global.PlayerCanMove = false

func walkright():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Run/blend_position", dir.RIGHT)
	animationState.travel("Run")
#	pass

func walkleft():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Run/blend_position", dir.LEFT)
	animationState.travel("Run")
	
func walkup():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Run/blend_position", dir.UP)
	animationState.travel("Run")
	
func walkdown():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Run/blend_position", dir.DOWN)
	animationState.travel("Run")
	
func idledown():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Idle/blend_position", dir.DOWN)
	animationState.travel("Idle")
	
func idleright():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Idle/blend_position", dir.RIGHT)
	animationState.travel("Idle")
	
func idleup():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Idle/blend_position", dir.UP)
	animationState.travel("Idle")

func idleleft():
	var mikeanim = MSG.level_root().get_node("main/Mike Hawke/AnimationTree")
	var animationState = mikeanim.get("parameters/playback")
	mikeanim.set("parameters/Idle/blend_position", dir.LEFT)
	animationState.travel("Idle")

func fridge():
	if MSG.level_root().get_node("FridgeOpen").visible == true:
		MSG.level_root().get_node("FridgeOpen").visible = false
	else:
		MSG.level_root().get_node("FridgeOpen").visible = true

func seq1():
	walkright()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt1")
	

func seq2():
	walkdown()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt2")

func seq3():
	
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt3")

func seq4():
	walkdown()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt4")

func seq5():
	walkdown()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt5")

func seq6():
	walkright()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt6")

func seq7():
	walkleft()
	MSG.level_root().get_node("main/Mike Hawke/AnimationPlayer2").play("Seq1Pt7")
	
func end_sequence1():
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

