extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
		get_tree().change_scene_to_file("res://Battle_System/fight_screen_mob.tscn")
		PlayerState.scene = "res://dungeon/floor 3/D_3_F_1_R_1.tscn"
		PlayerState.mob = "res://Battle/treant.tres"
	
