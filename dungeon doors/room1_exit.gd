extends Area2D


# Called when the node enters the scene tree for the first time.


func _on_body_entered(body):
	get_tree().change_scene_to_file("res://town.tscn")
	PlayerState.scene = "res://town.tscn" 
	PlayerState.pos = Vector2(520,125)
