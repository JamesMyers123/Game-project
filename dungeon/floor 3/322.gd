extends Area2D


func _on_body_entered(body):
		get_tree().change_scene_to_file("res://Battle_System/fight_screen_mob.tscn")
		PlayerState.scene = "res://dungeon/floor 3/Dungeon_3_2_2.gd"
		PlayerState.mob = "res://Battle/Stone_Golem.tres"
