extends Area2D



func _on_body_entered(body):
	pass
	if PlayerState.boss3: #true for testing false for release
		get_tree().change_scene_to_file("res://End.tscn")
		PlayerState.scene = "res://End.tscn"
		
