extends Area2D






func _on_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/Dungeon_Floor_1_room_1.tscn")
	PlayerState.scene = "res://dungeon/Dungeon_Floor_1_room_1.tscn"
	PlayerState.pos = Vector2(791,10)
