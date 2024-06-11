extends Node



func _on__1_room_2_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor2/Dungeon_2_Floor_3_room3.tscn")
	PlayerState.scene = "res://dungeon/floor2/Dungeon_2_Floor_3_room3.tscn"
	PlayerState.pos = Vector2(450,625)


func _on__1_room_1_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor2/Dungeon_2_Floor_3_room2.tscn")
	PlayerState.scene = "res://dungeon/floor2/Dungeon_2_Floor_3_room2.tscn"
	PlayerState.pos = Vector2(450,625)


func _on_exit_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn")
	PlayerState.scene = "res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn"
	PlayerState.pos = Vector2(791,10)
