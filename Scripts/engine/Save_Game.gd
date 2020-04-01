extends Node




var settings = {}
var save_path
var id
var files = []

func _ready():
	pass
#	new_game()
#load_game()



func save_game():
	Global.save_id = int(Global.save_id)
	if Global.save_id == 0:
		set_save_path()
	Global.save_game()
	id = String(Global.save_id)
	save_path = "res://Save/" + id + ".json"
	var save_d = {}
	var nodes_to_save = get_tree().get_nodes_in_group("save")
	for node in nodes_to_save:
		save_d[node.get_path()] = node.save_game()
	var save_file = File.new()
	save_file.open(save_path, File.WRITE)
	save_d = to_json(save_d)
	save_file.store_line(save_d)
	save_file.close()
	pass

func set_save_path():
	list_files_in_directory()
	if Global.save_id == 0:
		Global.save_id = Global.array_load_files.size() + 1
#		print(Global.save_id)

	id = String(Global.save_id)
	save_path = "res://Save/" + id + ".json"
	var directory = Directory.new();
	var doFileExists = directory.file_exists(save_path)
	
#	if Global.new_game == true:
	while doFileExists:
		Global.save_id = Global.save_id + 1
		id = String(Global.save_id)
		save_path = "res://Save/" + id + ".json"
		directory = Directory.new();
		doFileExists = directory.file_exists(save_path)
#		print(save_path)

func load_game():
	
	var load_path = Global.load_path
#	var id = String(Global.save_id)

	var load_file = File.new()

	if not load_file.file_exists(load_path):
#		print("not found")
		return
	load_file.open(load_path, File.READ)
	var data = {}
#	data.parse_json(load_file.get_as_text())
	data = parse_json(load_file.get_as_text())
	for node_path in data.keys():
		var node = get_node(node_path)
		for attribute in data[node_path]:
			node.set(attribute, data[node_path][attribute])


func list_files_in_directory():
	var path = "res://Save"
	files = []
	var dir = Directory.new()
	Global.array_load_files.clear()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			Global.array_load_files.append(file)
#			Global.array_load_files.sort()

	dir.list_dir_end()
	files.sort_custom(MyCustomSorter, "sort_ascending")
	return files


func new_game():
	ImportData._ready()
	Global.save_dict.clear()

	var load_path = "res://Scripts/New_Game/New_Game.json"
	var load_file = File.new()

	if not load_file.file_exists(load_path):
#		print("not found")
		return
	load_file.open(load_path, File.READ)
	var data = {}
	data = parse_json(load_file.get_as_text())
	for node_path in data.keys():
		var node = get_node(node_path)
		for attribute in data[node_path]:
			node.set(attribute, data[node_path][attribute])


class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false
	
