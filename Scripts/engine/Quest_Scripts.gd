extends Node



func update_quest_0():
	var dict_quest = ImportData.quest_stats as Dictionary
	var dict_inventory = ImportData.inven_data as Dictionary
	if not ImportData.inven_data.has(Global.currency):
		dict_inventory[Global.currency] = [Global.currency, 0]
	dict_quest["0"]["Preq1"] = dict_inventory[Global.currency][1]
	if dict_quest["0"]["Preq1"] >= 85:
		dict_quest["0"]["Objective1Complete"] = true
	else:
		dict_quest["0"]["Objective1Complete"] = false
