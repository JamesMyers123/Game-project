extends Panel



func _on_button_pressed():
	$".".hide()
	PlayerState.base_damage = 15
	PlayerState.strength = 2
	PlayerState.endurance = 2
	PlayerState.dexterity  = 1
	PlayerState.gold = 0
	PlayerState.level = 2
	$"../Q2".show()
func _on_button_2_pressed():
	$".".hide()
	PlayerState.luck = 2
	PlayerState.level = 1
	PlayerState.gold = 500
	$"../Q2".show()
func _on_button_3_pressed():
	$".".hide()
	PlayerState.gold = 1000
	$"../Q2".show()

func _on_button_4_pressed():
	get_tree().quit()
