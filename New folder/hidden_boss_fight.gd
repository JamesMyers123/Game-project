extends Area2D

func _ready():
	if PlayerState.boss4:
		$".".hide()
	else:
		$".".show()
	
func _on_body_entered(body):
		if PlayerState.boss4:
			pass
		else:
			get_tree().change_scene_to_file("res://Battle_System/boss_4.tscn")
			PlayerState.scene = "res://dungeon/floor 3/Hidden_boss.tscn"
			PlayerState.mob = "res://Battle/Hidden_Boss.tres"
