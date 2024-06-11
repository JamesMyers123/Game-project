extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if DungeonState.room3_2_chest == true:
		$"../chest".show()
		#$"../chest open".hide()
	else:
		$"../chest".hide()
		#$"../chest open".show()

func _on_body_entered(body):
	if DungeonState.room3_2_chest == true:
		DungeonState.room3_2_chest = false
		$"../chest".hide()
		#$"../chest open".show()
		PlayerState.gold += 5000
