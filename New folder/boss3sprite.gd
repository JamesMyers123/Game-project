extends Area2D


func ready():
	if !PlayerState.boss3:
		$".".show()
	else:
		$".".hide()
func _on_body_entered(body):
	if !PlayerState.boss3:
		get_tree().change_scene_to_file("res://Battle_System/boss_3.tscn")
	else:
		pass #do nothing
