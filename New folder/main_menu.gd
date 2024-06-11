extends Control
var credits = false
var creator = true
var load = false
var save_path = "user://Savefile.save"

func _ready():
	$Panel.show()
	$Q1.hide()
	$Q2.hide()
	$Q3.hide()
	$Credits.hide()



func _on_credits_pressed():
	if credits == true:
		$Credits.hide()
		credits = false
	else:
		$Credits.show()
		credits = true


func _on_new_pressed():
	if creator == true:
		$Q1.show()
		creator = false
	else:
		pass
	#PlayerState.first_load = true
	#get_tree().change_scene_to_file("res://town.tscn")
	#PlayerState.scene = "res://town.tscn" 

#A very inefficent load function however due to its raw simplicity 
func _on_load_pressed():
	PlayerState.first_load = true
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.READ)
		print(PlayerState.boss1)
		print(PlayerState.boss2)
		print(PlayerState.boss3)
		print(PlayerState.boss4)
		
		PlayerState.level = file.get_var(PlayerState.level)
		PlayerState.current_health = file.get_var(PlayerState.current_health)
		PlayerState.current_mana = file.get_var(PlayerState.current_mana)
		PlayerState.gold = file.get_var(PlayerState.gold)
		PlayerState.base_health = file.get_var(PlayerState.base_health)
		PlayerState.base_mana = file.get_var(PlayerState.base_mana)
		PlayerState.base_damage = file.get_var(PlayerState.base_damage)
		PlayerState.base_magic = file.get_var(PlayerState.base_magic)
		PlayerState.max_health = file.get_var(PlayerState.max_health)
		PlayerState.max_mana = file.get_var(PlayerState.max_mana)
		PlayerState.crit = file.get_var(PlayerState.crit)
		PlayerState._range = file.get_var(PlayerState._range)
		PlayerState.magic = file.get_var(PlayerState.magic)
		PlayerState.damage = file.get_var(PlayerState.damage)
		PlayerState.strength = file.get_var(PlayerState.strength)
		PlayerState.intelligence = file.get_var(PlayerState.intelligence)
		PlayerState.dexterity = file.get_var(PlayerState.dexterity)
		PlayerState.endurance = file.get_var(PlayerState.endurance)
		PlayerState.Insight = file.get_var(PlayerState.Insight)
		PlayerState.luck = file.get_var(PlayerState.luck)
		PlayerState.Sword_1 = file.get_var(PlayerState.Sword_1)
		PlayerState.Sword_2 = file.get_var(PlayerState.Sword_2)
		PlayerState.Sword_3 = file.get_var(PlayerState.Sword_3)
		PlayerState.Staff_1 = file.get_var(PlayerState.Staff_1)
		PlayerState.Staff_2 = file.get_var(PlayerState.Staff_2)
		PlayerState.Staff_3 = file.get_var(PlayerState.Staff_3)
		PlayerState.Armor_1 = file.get_var(PlayerState.Armor_1)
		PlayerState.Armor_2 = file.get_var(PlayerState.Armor_2)
		PlayerState.Armor_3 = file.get_var(PlayerState.Armor_3)
		PlayerState.Ring_1 = file.get_var(PlayerState.Ring_1)
		PlayerState.Ring_2 = file.get_var(PlayerState.Ring_2)
		PlayerState.Ring_3 = file.get_var(PlayerState.Ring_3)
		
		print(PlayerState.boss1)
		print(PlayerState.boss2)
		print(PlayerState.boss3)
		print(PlayerState.boss4)
		get_tree().change_scene_to_file("res://town.tscn")
		PlayerState.boss1 = file.get_var(PlayerState.boss1)
		PlayerState.boss2 = file.get_var(PlayerState.boss2)
		PlayerState.boss3 = file.get_var(PlayerState.boss3)
		PlayerState.boss4 = file.get_var(PlayerState.boss4)
	else: 
		pass


func _on_exit_pressed():
	get_tree().quit()
