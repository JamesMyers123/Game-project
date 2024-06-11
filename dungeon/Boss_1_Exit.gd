extends Area2D





func _on_body_entered(body):
	if PlayerState.boss1: #true for testing false for release
		get_tree().change_scene_to_file("res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn")
		PlayerState.scene = "res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn"
		PlayerState.pos = Vector2(450,625)
	else:
		pass
