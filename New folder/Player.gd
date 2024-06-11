extends CharacterBody2D


const SPEED = 120
var current_face = "down"
var menu_open = false


func _physics_process(delta):
	Player_Movement(delta)
	
	

func Player_Movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_face = "right"
		play_animation(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_face = ("left")
		play_animation(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_face = ("down")
		play_animation(1)
		velocity.x = 0
		velocity.y = SPEED
	elif Input.is_action_pressed("ui_up"):
		current_face = ("up")
		play_animation(1)
		velocity.x = 0
		velocity.y = -SPEED
	else:
		play_animation(0)
		velocity.y = 0
		velocity.x = 0
		
	move_and_slide()
	
func play_animation(movement):
	var face = current_face
	var anim = $AnimatedSprite2D
	
	if face == "right": 
		if movement == 1:
			anim.play("Walk_Right")
			if $Timer.time_left <= 0:
				$Footstep.play()
				$Timer.start(.5)
		elif movement == 0:
			anim.play("Right_Idle")
			$Footstep.stop()
	elif face == "left": 
		if movement == 1:
			anim.play("Walk_Left")
			if $Timer.time_left <= 0:
				$Footstep.play()
				$Timer.start(.5)
		elif movement == 0:
			anim.play("Left_Idle")
			$Footstep.stop()
	elif face == "down": 
		if movement == 1:
			anim.play("Walk_Down")
			if $Timer.time_left <= 0:
				$Footstep.play()
				$Timer.start(.5)
		elif movement == 0:
			anim.play("Down_Idle")
			$Footstep.stop()
	elif face == "up": 
		if movement == 1:
			anim.play("Walk_Up")
			if $Timer.time_left <= 0:
				$Footstep.play()
				$Timer.start(.5)
		elif movement == 0:
			anim.play("Up_Idle")
			$Footstep.stop()

func Menu():
	if Input.is_action_pressed("Open_menu") and !menu_open:
		$Player/Camera2D/Menu.show()
	elif Input.is_action_pressed("Open_menu") and menu_open:
		$Player/Camera2D/Menu.hide()
