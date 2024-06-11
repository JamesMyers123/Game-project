extends Node2D
var pos
var gpos



func _ready():
	if PlayerState.first_load == true:
		$Player.position = Vector2(450,625)
		PlayerState.first_load = false
	else:
		$Player.position = PlayerState.pos
	
func _unhandled_key_input(event):
	if Input.is_action_just_pressed("Open_menu"):
			$Player/Camera2D/Menu.show()
			$Player/Camera2D/Menu/Panel/Level.text = "Level - %d" % [PlayerState.level]
			$Player/Camera2D/Menu/Panel/Health.text = "health - %d / %d" % [PlayerState.current_health, PlayerState.max_health]
			$Player/Camera2D/Menu/Panel/Mana.text = "Mana - %d / %d" % [PlayerState.current_mana, PlayerState.max_mana]
			$Player/Camera2D/Menu/Panel/Phys_Damage.text = "Attack Damage   %d - %d" % [round(PlayerState.damage * .8 + (.04 * PlayerState.dexterity)),round(PlayerState.damage * 1.2 + (.1 * PlayerState.dexterity))]
			$Player/Camera2D/Menu/Panel/Magic_Damage.text = "Magic Damage   %d - %d" %[round(PlayerState.magic * 1),round(PlayerState.magic * 2)]
			$Player/Camera2D/Menu/Panel/Str.text = "Strength - %d" % PlayerState.strength
			$Player/Camera2D/Menu/Panel/Dex.text = "Dexterity - %d" % PlayerState.dexterity
			$Player/Camera2D/Menu/Panel/Int.text = "Intelligence - %d" % PlayerState.intelligence
			$Player/Camera2D/Menu/Panel/End.text = "Endurance - %d" % PlayerState.endurance
			$Player/Camera2D/Menu/Panel/Ins.text = "Insight - %d" % PlayerState.Insight
			$Player/Camera2D/Menu/Panel/Luck.text = "Luck - %d" % PlayerState.luck
			$Player/Camera2D/Menu/Panel/Gold.text = "Gold - %d" % PlayerState.gold

func _on_menu_close_requested():
	$Player/Camera2D/Menu.hide()


func _on_area_2d_body_entered(body):
	$save.show()


func _on_save_close_requested():
	$save.hide()


func _on_area_2d_body_exited(body):
	$save.hide()

