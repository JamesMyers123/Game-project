extends Area2D



func _on_body_entered(body):
	pass
	if PlayerState.boss2: #true for testing false for release
		get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_1_R_1.tscn")
		PlayerState.scene = "res://dungeon/floor 3/D_3_F_1_R_1.tscn"
		
