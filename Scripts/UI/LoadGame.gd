extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var add_node = get_node("ScrollContainer/VBoxContainer")
# warning-ignore:unused_variable
	var path = "res://Save"
	
#	var dir = Directory.new()
#	dir.open(path)
#	dir.list_dir_begin()
	Save_Game.list_files_in_directory()
	var files = Save_Game.files
#	print(files)
	for i in range(0, files.size()):
		var file = files[i]
		if file == "":
			break
		elif not file.begins_with("."):
			Global.load_path = String("res://Save/" + file)
			Save_Game.load_game()
			var scene = load("res://Scenes/Buttons/LoadSaveFile.tscn")
			var scene_instance = scene.instance()
			scene_instance.set_name(file)
			add_node.add_child(scene_instance)
# warning-ignore:unused_variable
			var savefile = "Load File " + String(i)
			var date ="Date Saved: " + String(Global.Dict_static_time["day"]) + "/" + String(Global.Dict_static_time["month"]) + "/" + String(Global.Dict_static_time["year"])
			var hour ="Time Saved: " +  "%02d" % Global.Dict_static_time["hour"]
			var minute = "%02d" % Global.Dict_static_time["minute"]
			var time = String(hour) + ":" + String(minute) 
			var filename = "Load file " + String(Global.save_id)
			var location ="Player Location: " +  String(Global.Dict_locations[Global.load_scene])
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer2/LoadGame/Label").set_text(filename)
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer/Date").set_text(String(date))
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer/Time").set_text(String(time))
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer2/Filename").set_text(file)
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer/File").set_text(filename)
			scene_instance.get_node("MarginContainer2/HBoxContainer/VBoxContainer/Location").set_text(location)
			Global.save_id = file
			i += 1



func _on_Button_pressed():
	Global.setScene("res://Scenes/TitleScreen.tscn")
	



