extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	get_tree().change_scene_to_file("res://dungeon/floor 3/Boss_3.tscn")
	PlayerState.scene = "res://dungeon/floor 3/Boss_3.tscn"
	PlayerState.pos = Vector2(450,625)

