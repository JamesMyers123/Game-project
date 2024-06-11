extends Area2D

func ready():
	if !PlayerState.boss1:
		$".".show()
	else:
		$".".hide()
func _on_body_entered(body):
	if !PlayerState.boss1:
		get_tree().change_scene_to_file("res://Battle_System/boss_1.tscn")
	else:
		pass #do nothing
