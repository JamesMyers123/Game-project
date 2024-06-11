extends Area2D


func _on_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor2/Boss_2.tscn")
	PlayerState.scene = "res://dungeon/floor2/Boss_2.tscn"
	PlayerState.pos = Vector2(450,625)
