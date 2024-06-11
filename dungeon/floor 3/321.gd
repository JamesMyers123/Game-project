extends Area2D



func _on_body_entered(body):
		get_tree().change_scene_to_file("res://Battle_System/fight_screen_mob.tscn")
		PlayerState.scene = "res://dungeon/floor 3/D_3_F_2_R_1.tscn"
		PlayerState.mob = "res://Battle/Vampire.tres"
