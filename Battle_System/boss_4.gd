extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_player_mana = 0
var current_enemy_health = 0
var rng = RandomNumberGenerator.new()
var is_defending = false
var low = .8 + (.04 * PlayerState.dexterity)
var high = 1.2 + (.1 * PlayerState.dexterity)
var turn = 0
var Enemy_windup = false
var Player_charge = 0
var charge = 0 #player
var gold = 0
var enemy_max_health = 0
var check_1 = false
var check_2 = false
var check_3 = false
var check_4 = false
var check_5 = false
var dialog_1 = false
var dialog_2 = false
var dialog_3 = false
#fight variables to controll the scripts.
#1
var Boss_charge = 0
var Boss_turn = 0
var Boss_enrage = 1
#2
var Boss_magic_stacks = 0 
var Boss_charges = 0 
#3
var Boss_flow = 0 
var Boss_awakening = 0

var Boss_new_Max =40000
var boss_max = 10000

func _ready():
	#Elowenna the Fearless
	enemy = load("res://Battle/Hidden_Boss.tres")
	current_player_health = PlayerState.current_health
	current_player_mana = PlayerState.current_mana
	current_enemy_health = enemy.health * (1 + PlayerState.NG * .2)
	enemy_max_health = enemy.health * (1 + PlayerState.NG * .2)
	gold = (enemy.gold * (1 + (PlayerState.luck * .1)))
	
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	set_mana($PlayerMana/ProgressBar, PlayerState.current_mana, PlayerState.max_mana)
	$EnemyContainer/Enemy.texture = enemy.texture
	#this is to fix a weird bug where the bars dont update correcty
	#this is easier and less buggy then actually fixing the issue 
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, PlayerState.current_health, PlayerState.max_health)
	set_mana($PlayerMana/ProgressBar, PlayerState.current_mana, PlayerState.max_mana)
	
	$Textbox.hide()
	$ActionsPanel.hide()
	$Spells.hide()
	$Attack.hide()
	
	display_text("You engage a %s!" % enemy.name.to_upper())
	await self.textbox_closed
	

	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]
func set_player_state():
	PlayerState.current_health = current_player_health
	PlayerState.current_mana = current_player_mana
func set_mana(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "Mana: %d/%d" % [health, max_health]

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		await get_tree().create_timer(0.1).timeout
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	var Ehit = (rng.randi_range(20,40) * (1 + (PlayerState.NG * .2)))
	var damage = Ehit
	var chance = rng.randi_range(1,10)
	
	if current_enemy_health <= .5 * enemy_max_health and !check_1:#Phase 2 entirely diffrent moveset reset on damage scale
		check_1 = true
		check_2 = true
		$BGM.play()
		display_text("The %s Unleashes a perfect flurry of attacks none lethal but incredably painful" % enemy.name)
		await self.textbox_closed
		current_player_health = 1
		$BigHit.play()
		$Hit.play()
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("%s : You have done well to find me and remind me of who I was" % enemy.name)
		await self.textbox_closed
		display_text("Elowenna : I am Elowenna the Fearless if I must fall today alow me to do so as myself")
		await self.textbox_closed
		display_text("You have been healed")
		await self.textbox_closed
		display_text("Elowenna : From our clashes of steel the swords will sing.")
		await self.textbox_closed
		current_enemy_health = Boss_new_Max
		boss_max = Boss_new_Max
		set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
		current_player_mana = PlayerState.max_mana
		current_player_health = PlayerState.max_health
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .9 * enemy_max_health and !dialog_1:
		display_text("Who is there Why are you hurting me?")
		await self.textbox_closed
		dialog_1 = true
	elif current_enemy_health <= .8 * enemy_max_health and !dialog_2:
		display_text("He isnt going to like this don't put me back into the dark")
		await self.textbox_closed
		dialog_2 = true
	elif current_enemy_health <= .7 * enemy_max_health and !dialog_3:
		display_text("This feeling why does it feel familiar")
		await self.textbox_closed
		dialog_3 = true
	elif current_enemy_health <= .60 * enemy_max_health and !check_2:#Damage and dialog
		check_2 = true
		display_text("Leave me alone")
		await self.textbox_closed
		$BigHit.play()
		display_text("You take %d damage" % 200)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - 200)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .7 * Boss_new_Max and check_1 and !check_3:# second hp trigger dialog and new moveset heal to 60%
		check_3 = true
		current_enemy_health = (.8* Boss_new_Max)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
		display_text("Elowenna : You have met Vance he had a mighty axe arm in his prime.")
		await self.textbox_closed
		display_text("Elowenna : Now he is but a husk of his formor glory.")
		await self.textbox_closed
		$BigHit.play()
		display_text("You take %d damage" % 200)
		await self.textbox_closed
		$EnemyContainer/Element.text = "Phase 2"
		current_player_health = max(0, current_player_health - 200)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .6 * Boss_new_Max and check_3 and !check_4:# second hp trigger dialog and new moveset heal to 35%
		check_4 = true
		current_enemy_health = (.7 * Boss_new_Max)
		$EnemyContainer/Element.text = "Phase 3"
		set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
		display_text("Elowenna : Melriel once a master of the arcane now an elemental.")
		await self.textbox_closed
		display_text("Elowenna : Now her new form can bairly contain her old power.")
		await self.textbox_closed
		$BigHit.play()
		display_text("You take %d damage" % 200)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - 200)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .4 * Boss_new_Max and check_4 and !check_5:# second hp trigger dialog and new moveset heal to 25%
		check_5 = true
		current_enemy_health = (.6 * Boss_new_Max)
		$EnemyContainer/Element.text = "Phase 4"
		set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
		current_player_health = max(0, current_player_health - 200)
		display_text("Elowenna : And now for me once an andventurer now eternaly dammed to this.")
		await self.textbox_closed
		display_text("Elowenna : I was once called the fearless from my inablitty to back down.")
		await self.textbox_closed
		display_text("Elowenna the Awakened : The title may no longer suit me however I shall never forgot who I once was.")
		await self.textbox_closed
		display_text("Elowenna the Awakened : One final battle as myself I shall savor the feeling forever.")
		await self.textbox_closed
		$BigHit.play()
		display_text("You take %d damage" % 200)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - 200)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		$ActionsPanel/buttons/Guard.hide()
		display_text("The attack slashed your shield in half you throw it away.")
		await self.textbox_closed
	elif check_5:# more damage unblockables dueling 
		var manadrain = rng.randi_range(5,10)
		damage = damage * 2
		if Boss_flow >= 20: #big signature attack multi hit to look cool
			display_text("Elowenna : My sword shall sing")
			await self.textbox_closed
			$BigHit.play()
			damage = rng.randi_range(50,100)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(50,100)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(40,80)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(30,60)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(1,20)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(1,20)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			damage = rng.randi_range(1,20)
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif  Boss_awakening >= 200: #one shot kill hard enrage
			display_text("Elowenna : You will not survive what is to come and for that I must stop you here.")
			await self.textbox_closed
			display_text("Elowenna : I am sorry but your story ends here with me.")
			await self.textbox_closed
			current_player_health = 0
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 1 or chance == 2: #Large magic #flow +1 awakeing +4 *1 damage
			Boss_awakening += 4
			Boss_flow += 1
			display_text("Elowenna Swings her sword")
			await self.textbox_closed
			$Hit.play()
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 3 or chance == 4: #Large magic #flow +2 awakeing +3 * 1 damage and 5-10 mana damage if mana = empty bonus mana burn
			Boss_awakening += 3
			Boss_flow += 2
			display_text("Elowenna thrusts her sword at you and drains some MP")
			await self.textbox_closed
			$Hit.play()
			$heal.play()
			display_text("you take %d damage and lose %d mana" % [damage, manadrain])
			await self.textbox_closed
			current_player_mana -= manadrain
			set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			if current_player_mana == 0:
				display_text("you take %d damage from mana burn" % (manadrain * 3))
				await self.textbox_closed
				current_player_health = max(0, current_player_health - (manadrain * 3))
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
				
		elif chance == 5 or chance == 6: #Large magic #flow +3 awakeing +2  "20" damage or if below 50% *2 damage
			Boss_awakening += 2
			Boss_flow += 3
			display_text("Elowenna Swings her sword directly down at you")
			await self.textbox_closed
			if current_player_health > (.5 * PlayerState.max_health):
				$Hit.play()
				display_text("you take %d damage" % 20)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - 20)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				$BigHit.play()
				display_text("you take %d damage" % damage * 2)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage * 2)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 7 or chance == 8: #Large magic #flow +4 awakeing +1  * .6 damage twice "twin strike"
			Boss_awakening += 1
			Boss_flow += 4
			
			display_text("Elowenna Swings her sword left then quickly right")
			await self.textbox_closed
			$Hit.play()
			display_text("you take %d damage" % damage *.6)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage * .6)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			display_text("you take %d damage" % damage * .6)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage * .6)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 9: #Large magic charge flow to 10 .5 damage three times blade flury
			damage = damage * .5
			Boss_flow = 10
			display_text("Elowenna dances around you strikeing you several times")
			await self.textbox_closed
			$Hit.play()
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			$Hit.play()
			display_text("you take %d damage" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 10: #Large magic charge flow to 10 .2 damage single hit plus 300 heal for boss
			Boss_flow = 10
			damage = damage * 2
			$BigHit.play()
			display_text("Elowenna thrusts her sword at you, your blood being absorbed into her sword")
			await self.textbox_closed
			display_text("you take %d damage and Elowenna heals for 300" % damage)
			await self.textbox_closed
			current_enemy_health += 300
			set_health($EnemyContainer/ProgressBar, current_enemy_health, Boss_new_Max)
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			
		$ActionsPanel/buttons/Guard.hide()
	elif check_4:# more damage elemental spells Melriel
		damage = damage * 1.5
		if Boss_magic_stacks >= 5: # big hit
			Boss_magic_stacks = 0
			damage = damage * 2
			display_text("Elowenna casts Mana Burst")
			await self.textbox_closed
			$Smite.play()
			$BigHit.play()
			display_text("you take %d damage past your guard" % damage/4)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif Boss_charges >= 3: #very large hit soft enrage
			Boss_charges = 0
			damage = damage * 4
			display_text("Elowenna casts Black Hole Disintegration")
			await self.textbox_closed
			$Smite.play()
			$BigHit.play()
			display_text("you take %d damage past your guard" % damage/4)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 1 or chance == 2: #Basic magic
			Boss_magic_stacks += 1
			if is_defending:
				display_text("Elowenna casts Mana Bolt")
				await self.textbox_closed
				$FireBall.play()
				$FrostBolt.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna casts Mana Bolt")
				await self.textbox_closed
				$FireBall.play()
				$FrostBolt.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 3 or chance == 4: #Large magic 
			Boss_magic_stacks += 2
			damage = damage * 1.5
			if is_defending:
				display_text("Elowenna casts mana blast")
				await self.textbox_closed
				$FireBall.play()
				$FrostBolt.play()
				$LightningBolt.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna casts mana blast")
				await self.textbox_closed
				$FireBall.play()
				$FrostBolt.play()
				$LightningBolt.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 5 or chance == 6: #charge magic +4 low damage
			damage = damage * .75
			Boss_magic_stacks += 4
			if is_defending:
				display_text("Elowenna enhances her sword with magical energy and strikes you")
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna enhances her sword with magical energy and strikes you")
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 7 or chance == 8: #Arcane burst large damage with +2 charge
			damage = damage * .5
			if is_defending:
				display_text("Elowenna strikes you with her sword")
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna strikes you with her sword")
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 9 or chance  == 10:
			Boss_charges += 1
			display_text("Elowenna begins to channel something")
			await self.textbox_closed
	elif check_3:# more damage chargeing and power moves Vance
		damage = damage * 1.5
		Boss_turn += 1
		if Boss_charge == 1:
			Boss_charge = 0
			damage = damage * 2 * Boss_enrage
			if is_defending:
				display_text("Elowenna : Can you withstand this?")
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % (damage/4))
				await self.textbox_closed
				current_player_health = max(0, current_player_health - (damage/4))
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna : Can you withstand this?")
				await self.textbox_closed
				$BigHit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif Boss_turn == 4:
			Boss_charge = 1
			display_text("Elowenna raises her sword high in the air")
			await self.textbox_closed
		elif chance >=1 and chance <= 5:
			damage = damage * Boss_enrage
			if is_defending:
				display_text("Elowenna attacks quickly")
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna attacks quickly")
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance >= 6 and chance <= 10:
			damage = damage * .8 * Boss_enrage
			Boss_enrage += .1
			if is_defending:
				display_text("Elowenna delivers an enrageing slash")
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("Elowenna delivers an enrageing slash")
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			
	elif check_1:# start of phase 2 
		damage = damage * 2
		if chance >= 1 and chance <= 5:
			if is_defending:
				display_text("%s swings its weapon at you" % enemy.name)
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("%s swings its weapon at you" % enemy.name)
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance >= 6 and chance <= 10:
			if is_defending:
				display_text("%s swings its weapon at you" % enemy.name)
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("%s swings its weapon at you" % enemy.name)
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	else:# base moveset 
		if chance >= 1 and chance <= 2: # do nothing
			display_text("%s Does nothing seemily to fearful to do anything" % enemy.name)
			await self.textbox_closed
		elif chance >= 3 and chance <= 6:# weak attack
			if dialog_3:
				damage = damage * .9
			else: 
				damage = damage * .5 
			if is_defending:
				display_text("%s : Why are you here" % enemy.name)
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("%s : Why are you here" % enemy.name)
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance >= 7 and chance <= 10:# generic attack
			if is_defending:
				display_text("%s : Go away" % enemy.name)
				await self.textbox_closed
				$BlockHit.play()
				display_text("you take %d damage past your guard" % damage/4)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("%s : Go away" % enemy.name)
				await self.textbox_closed
				$Hit.play()
				display_text("you take %d damage" % damage)
				await self.textbox_closed
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	if current_player_health == 0:
		display_text("You were slain")
		await self.textbox_closed
		set_player_state()
		PlayerState.current_health = PlayerState.max_health
		PlayerState.current_mana = PlayerState.max_mana
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://Battle_System/boss_4.tscn")
		
	is_defending = false
	$Button.show()
	$ActionsPanel.show()
	
	
func _on_skills_pressed():
	$Attack.show()
	
func _on_attack_pressed():
	$Attack.hide()
	$Spells.hide()
	display_text("You swing your weapon!")
	await self.textbox_closed
	var crit = 1
	var hit = rng.randi_range((round(PlayerState.damage * low)), (round(PlayerState.damage * high)))
	var damage = 0
	if Player_charge > 0:
		hit = hit * Player_charge
		Player_charge = 0
		charge = 0
		display_text("You expend your charge")
		await self.textbox_closed
	if rng.randi_range(0,100) <= PlayerState.crit:
		crit = 2

	damage = (hit*crit)
	current_enemy_health = max(0, current_enemy_health - damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
	
	if crit == 2 or charge > 0:
		$BigHit.play()
		charge = 0
		if charge > 0:
			display_text("You dealt %d damage!" % damage)
			await self.textbox_closed
		else:
			display_text("You dealt %d damage! Crit!" % damage)
			await self.textbox_closed
	else:
		$Hit.play()
		display_text("You dealt %d damage!" % damage)
		await self.textbox_closed
	
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()
func _on_charge_pressed():
	$Attack.hide()
	$Spells.hide()
	if Player_charge < 6:
		charge = charge + 1
		Player_charge = Player_charge + charge
		display_text("You charge up for a big attack %d" % Player_charge)
		await self.textbox_closed
		turn += 1
		enemy_turn()
	elif Player_charge == 6:
		display_text("You are at max charge")
		await self.textbox_closed
		turn += 1
		enemy_turn()
func _on_vampiric_thust_pressed():
	$Attack.hide()
	$Spells.hide()
	display_text("You thrust your sword encanced with vamperic energy")
	var hit = rng.randi_range((round(PlayerState.damage * low)), (round(PlayerState.damage * high)))
	var damage = hit * .8
	var crit = 0
	if charge > 0:
		damage = damage * Player_charge
		Player_charge = 0
		charge = 0
		display_text("You expend your charge")
		await self.textbox_closed
		$heal.play()
		$BigHit.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		current_player_health = min(PlayerState.max_health, current_player_health + (damage/2))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and healed for %d" % [damage, (damage/4)])
		await self.textbox_closed
	else:
		$Hit.play()
		$heal.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		current_player_health = min(PlayerState.max_health, current_player_health + (damage/2))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d damage and healed for %d" % [damage,damage/4])
		await self.textbox_closed
		
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()
func _on_dark_slash_pressed():
	$Attack.hide()
	$Spells.hide()
	var hit = rng.randi_range((round(PlayerState.damage * low)), (round(PlayerState.damage * high)))
	var damage = hit * 1.5
	var crit = 0
	var recoil = PlayerState.current_health * .1
	display_text("You ready your sword with dark energy")
	if Player_charge > 0:
		damage = damage * Player_charge
		Player_charge = 0
		charge = 0
		display_text("You expend your charge")
		await self.textbox_closed
		$BigHit.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		current_player_health = max(0, current_player_health - recoil)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and took %d in return" % [damage, recoil])
		await self.textbox_closed
	else:
		$BigHit.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		current_player_health = max(1, current_player_health - recoil)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and took %d in return" % [damage, recoil])
		await self.textbox_closed
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()
func _on_wild_swing_pressed():
	$Attack.hide()
	$Spells.hide()
	display_text("You swing your weapon recklessly")
	var hit = rng.randi_range((round(PlayerState.damage * low)), (round(PlayerState.damage * high)))
	var damage = 0
	if Player_charge > 0:
		hit = hit * Player_charge
		Player_charge = 0
		charge = 0
		display_text("You expend your charge")
		await self.textbox_closed
	if rng.randi_range(0,100) <= 50:
		damage = hit * 2.5
		$BigHit.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		display_text("You hit with a savage crit dealing %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("Your swing missed and you deal no damage")
		await self.textbox_closed
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()
func _on_cancel_a_pressed():
	$Attack.hide()

func _on_guard_pressed():
	$Spells.hide()
	$Attack.hide()
	is_defending = true
	
	display_text("You prepare defensively!")
	await self.textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	turn += 1
	enemy_turn()

func _on_spells_pressed():
	$Spells.show()
	#fireballl
	#frostbolt
	#lighting
	#heal
	#smite 
	#cancel

func _on_fireball_pressed():
	$Spells.hide()
	$Attack.hide()
	await get_tree().create_timer(0.25).timeout
	display_text("You prepare to cast FireBall")
	await self.textbox_closed

	var damage = rng.randi_range((round(PlayerState.magic * 1)), (round(PlayerState.magic * 2))) 
	if current_player_mana >= 10:
		$FireBall.play()
		
		$EnemyContainer/Element.text = "Fire"
		current_player_mana = max(0,current_player_mana - 10)
		current_enemy_health = max(0, current_enemy_health - damage)
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()

func _on_frostbolt_pressed():
	$Spells.hide()
	$Attack.hide()
	await get_tree().create_timer(0.25).timeout
	display_text("You prepare to cast FrostBolt")
	await self.textbox_closed

	var damage = rng.randi_range((round(PlayerState.magic * 1)), (round(PlayerState.magic * 2))) 

	if current_player_mana >= 10:
		$FrostBolt.play()

		$EnemyContainer/Element.text = "Ice"
		current_player_mana = max(0,current_player_mana - 10)
		current_enemy_health = max(0, current_enemy_health - damage)
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()

func _on_lightning_pressed():
	$Spells.hide()
	$Attack.hide()
	await get_tree().create_timer(0.25).timeout
	display_text("You prepare to cast Lightning")
	await self.textbox_closed

	var damage = rng.randi_range((round(PlayerState.magic * 1)), (round(PlayerState.magic * 2))) 

	if current_player_mana >= 10:
		$LightningBolt.play()

		$EnemyContainer/Element.text = "Lightning"
		current_player_mana = max(0,current_player_mana - 10)
		current_enemy_health = max(0, current_enemy_health - damage)
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()

func _on_heal_pressed():
	$Attack.hide()
	$Spells.hide()
	display_text("You prepare to cast healing magic")
	await self.textbox_closed
	var heal = rng.randi_range((round(PlayerState.magic * .5)), (round(PlayerState.magic * 2)))
	if current_player_mana >= 5:
		$heal.play()
		current_player_mana = max(0,current_player_mana - 5)
		current_player_health = min(PlayerState.max_health, current_player_health + heal)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		display_text("You healed for %d!" % heal)
		await self.textbox_closed
		turn += 1

		enemy_turn()
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()

func _on_smite_pressed():
	$Spells.hide()
	$Attack.hide()
	await get_tree().create_timer(0.25).timeout
	display_text("You prepare to Smite!")
	await self.textbox_closed
	var damage = rng.randi_range((round(PlayerState.magic * 1.5)), (round(PlayerState.magic * 2))) 
	if current_enemy_health <= (enemy.health/4):
		damage = damage * 3
	if current_player_mana >= 15:
		$Smite.play()

		$EnemyContainer/Element.text = "Holy"
		current_player_mana = max(0,current_player_mana - 15)
		current_enemy_health = max(0, current_enemy_health - damage)
		set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, boss_max)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss4 = true
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		set_player_state()
		display_text("you gain %d gold!" % gold)
		await self.textbox_closed
		PlayerState.gold = PlayerState.gold + gold
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file(PlayerState.scene)
	turn += 1
	enemy_turn()

func _on_cancel_pressed():
	$Spells.hide()

func _on_button_pressed():
	$Spells.hide()
	$Attack.hide()
	$Button.hide()
	var gen = PlayerState.max_mana * .1 
	if gen < 5:
		gen = 5 
	display_text("You spend your turn to generate %d mana" % gen)
	await self.textbox_closed
	current_player_mana = min(PlayerState.max_mana ,current_player_mana + gen)
	set_mana($PlayerMana/ProgressBar, current_player_mana, PlayerState.max_mana)
	turn += 1
	enemy_turn()


