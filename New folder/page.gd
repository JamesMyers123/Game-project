extends Sprite2D


func _ready():
	pass
	
func _on_hidden_area_body_entered(body):

	$Note.show()



func _on_hidden_area_body_exited(body):
	$Note.hide()


func _on_note_close_requested():
	$Note.hide()
