extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	PlayerState.strength += 1
	PlayerState.endurance += 1
	PlayerState.level += 1
	PlayerState.first_load = true
	
	PlayerState.scene = "res://town.tscn"
	get_tree().change_scene_to_file("res://town.tscn")

func _on_button_2_pressed():
	PlayerState.dexterity += 1
	PlayerState.luck += 1
	PlayerState.level += 1
	PlayerState.first_load = true
	
	PlayerState.scene = "res://town.tscn"
	get_tree().change_scene_to_file("res://town.tscn")

func _on_button_3_pressed():
	PlayerState.intelligence += 1
	PlayerState.Insight += 1
	PlayerState.level += 1
	PlayerState.first_load = true
	
	PlayerState.scene = "res://town.tscn"
	get_tree().change_scene_to_file("res://town.tscn")

func _on_button_4_pressed():
	get_tree().quit()
