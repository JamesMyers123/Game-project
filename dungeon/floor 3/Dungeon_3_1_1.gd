extends Node


func _on_exit_body_entered(body):
	get_tree().change_scene_to_file("res://town.tscn")
	PlayerState.scene = "res://town.tscn" 
	PlayerState.pos = Vector2(520,125)


func _on__1_room_2_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_2_R_2.tscn")
	PlayerState.scene = "res://dungeon/floor 3/D_3_F_2_R_2.tscn"
	PlayerState.pos = Vector2(450,625)


func _on__1_room_1_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_2_R_1.tscn")
	PlayerState.scene = "res://dungeon/floor 3/D_3_F_2_R_1.tscn"
	PlayerState.pos = Vector2(450,625)
