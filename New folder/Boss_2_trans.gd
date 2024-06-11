extends Area2D


func ready():
	if !PlayerState.boss2:
		$".".show()
	else:
		$".".hide()
func _on_body_entered(body):
	if !PlayerState.boss2:
		get_tree().change_scene_to_file("res://Battle_System/boss_2.tscn")
	else:
		pass #do nothing

