extends Window


var save_path = "user://Savefile.save"
func ready():
	$".".hide()
func _on_button_pressed():
	save()
	$".".hide()
func save():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(PlayerState.level)
	file.store_var(PlayerState.current_health)
	file.store_var(PlayerState.current_mana)
	file.store_var(PlayerState.gold)
	file.store_var(PlayerState.base_health)
	file.store_var(PlayerState.base_mana)
	file.store_var(PlayerState.base_damage)
	file.store_var(PlayerState.base_magic)
	file.store_var(PlayerState.max_health)
	file.store_var(PlayerState.max_mana)
	file.store_var(PlayerState.crit)
	file.store_var(PlayerState._range)
	file.store_var(PlayerState.magic)
	file.store_var(PlayerState.damage)
	file.store_var(PlayerState.strength)
	file.store_var(PlayerState.intelligence)
	file.store_var(PlayerState.dexterity)
	file.store_var(PlayerState.endurance)
	file.store_var(PlayerState.Insight)
	file.store_var(PlayerState.luck)
	file.store_var(PlayerState.Sword_1)
	file.store_var(PlayerState.Sword_2)
	file.store_var(PlayerState.Sword_3)
	file.store_var(PlayerState.Staff_1)
	file.store_var(PlayerState.Staff_2)
	file.store_var(PlayerState.Staff_3)
	file.store_var(PlayerState.Armor_1)
	file.store_var(PlayerState.Armor_2)
	file.store_var(PlayerState.Armor_3)
	file.store_var(PlayerState.Ring_1)
	file.store_var(PlayerState.Ring_2)
	file.store_var(PlayerState.Ring_3)
	
	file.store_var(PlayerState.boss1)
	file.store_var(PlayerState.boss2)
	file.store_var(PlayerState.boss3)
	file.store_var(PlayerState.boss4)
	print(PlayerState.boss1)
	print(PlayerState.boss2)
	print(PlayerState.boss3)
	print(PlayerState.boss4)

func _on_button_2_pressed():
	save()
	get_tree().quit()


func _on_close_requested():
	pass # Replace with function body.
