extends Area2D


func _on_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/Hidden_boss.tscn")
	PlayerState.scene = "res://dungeon/floor 3/Hidden_boss.tscn"
	PlayerState.pos = Vector2(450,625)

