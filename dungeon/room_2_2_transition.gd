extends Area2D




func _on_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/Dungeon_Floor_3_room_2.tscn")
	PlayerState.scene = "res://dungeon/Dungeon_Floor_3_room_2.tscn"
	PlayerState.pos = Vector2(450,625)
