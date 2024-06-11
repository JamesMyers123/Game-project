extends Node

func _on_exit_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_1_R_1.tscn")
	PlayerState.scene = "res://dungeon/floor 3/D_3_F_1_R_1.tscn"
	PlayerState.pos = Vector2(791,10)


func _on__1_room_2_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_3_R_2.tscn")
	PlayerState.scene = "res://dungeon/floor 3/D_3_F_3_R_2.tscn"
	PlayerState.pos = Vector2(450,625)


func _on__1_room_1_transition_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_3_R_3.tscn")
	PlayerState.scene = "res://dungeon/floor 3/D_3_F_3_R_3.tscn"
	PlayerState.pos = Vector2(450,625)


func _on_exit_body_exited(body):
	pass # Replace with function body.
