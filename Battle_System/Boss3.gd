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
var doom = false
var doom_counter = 0
var enrage = 1
var check_1 = false
var check_2 = false
var check_3 = false
var check_4 = false
var check_5 = false

func _ready():
	enemy = load("res://Battle/Boss_death.tres")
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
	if PlayerState.boss4:
		display_text("Reaper : You killed my new toy a shame but you will make a fine replacement")
		await self.textbox_closed
		display_text("Reaper : Your soul shall serve me even in ")
		await self.textbox_closed
	else:
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
	var Ehit = (rng.randi_range(10,20) * (1 + (PlayerState.NG * .2)))
	var damage = Ehit
	if turn == 30 and doom == false:#doom enrage starts
		doom = true
		display_text("The Reaper Dooms you")
		await self.textbox_closed
	if doom_counter == 5:
		display_text("Doom triggerd killing you instantly")
		await self.textbox_closed
		set_player_state()
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://town.tscn")
		PlayerState.scene = "res://town.tscn"
	if doom:
		enrage += 1
		doom_counter += 1
		damage = Ehit * enrage
		display_text("The Reaper deals %d to you" % damage)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .9 * enemy_max_health and !check_1:#static 250 damage 
		check_1 = true
		damage = 250
		display_text("The Reaper unleashes its deadly aura")
		await self.textbox_closed
		display_text("The Reaper deals %d to you" % damage)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .75 * enemy_max_health and !check_2:#static 500 damage
		check_2 = true
		damage = 500
		display_text("The Reaper unleashes its deadly aura")
		await self.textbox_closed
		display_text("The Reaper deals %d to you" % damage)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .5 * enemy_max_health and !check_3:#expanded moveset
		check_3 = true 
		display_text("The Reaper absorbs the energy of the dead its power swells")
		await self.textbox_closed
	elif current_enemy_health <= .25 * enemy_max_health and !check_4:#static 750 damage expanded moveset
		check_4 = true
		damage = 750
		display_text("The Reaper unleashes its deadly aura")
		await self.textbox_closed
		display_text("The Reaper deals %d to you" % damage)
		await self.textbox_closed
		current_player_health = max(0, current_player_health - damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif current_enemy_health <= .05 * enemy_max_health and !check_5:#doom enrage starts
		check_5 = true
		doom = true
		display_text("The Reaper Dooms you")
		await self.textbox_closed
	
	if check_3:
		var chance = rng.randi_range(1,4)
		damage = Ehit
		if chance == 1:
			if is_defending:
				damage = Ehit
				display_text("The Reaper swings his weapon at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard" % damage/4)
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("The Reaper swings his weapon at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you" % damage)
				await self.textbox_closed
				$Hit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 2:
			damage = Ehit * 1.5
			if is_defending:
				damage = damage / 3
				display_text("The Reaper unleashes death magic at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard" % damage)
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("The Reaper unleashes death magic at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you" % damage)
				await self.textbox_closed
				$BigHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 3:
			damage = Ehit * 2
			if is_defending:
				damage = damage/4
				display_text("The Reaper absorbs your vitality.")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard and heals for %d" % [damage * 1.5,(damage * 1.5) /2])
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
				current_enemy_health = min(enemy.health, current_enemy_health + damage/2)
				set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
			else:
				display_text("The Reaper absorbs your vitality.")
				await self.textbox_closed
				display_text("The Reaper deals %d to you and heals for %d" % [damage * 1.5,(damage * 1.5) /2])
				await self.textbox_closed
				$BigHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
				current_enemy_health = min(enemy.health, current_enemy_health + damage/2)
				set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		elif chance == 4:
			damage = Ehit * rng.randi_range(1,4)
			if is_defending:
				damage = damage /4
				display_text("The Reaper swings wildly its desparation on full display")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard" % damage)
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("The Reaper swings wildly its desparation on full display")
				await self.textbox_closed
				display_text("The Reaper deals %d to you" % damage)
				await self.textbox_closed
				$BigHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	else:
		var chance = rng.randi_range(1,3)
		if chance == 1 or chance == 2:
			if is_defending:
				damage = Ehit
				display_text("The Reaper swings his weapon at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard" % damage/4)
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage/4)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("The Reaper swings his weapon at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you" % damage)
				await self.textbox_closed
				$Hit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		elif chance == 3:
			damage = Ehit * 1.5
			if is_defending:
				damage = damage / 3
				display_text("The Reaper unleashes death magic at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you past your guard" % damage)
				await self.textbox_closed
				$BlockHit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			else:
				display_text("The Reaper unleashes death magic at you")
				await self.textbox_closed
				display_text("The Reaper deals %d to you" % damage)
				await self.textbox_closed
				$Hit.play()
				current_player_health = max(0, current_player_health - damage)
				set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	if current_player_health == 0:
		display_text("You were slain")
		await self.textbox_closed
		set_player_state()
		PlayerState.pos = Vector2(800,520)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://town.tscn")
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
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
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
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		current_player_health = min(PlayerState.max_health, current_player_health + (damage/2))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and healed for %d" % [damage, (damage/4)])
		await self.textbox_closed
	else:
		$Hit.play()
		$heal.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		current_player_health = min(PlayerState.max_health, current_player_health + (damage/2))
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d damage and healed for %d" % [damage,damage/4])
		await self.textbox_closed
		
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		current_player_health = max(0, current_player_health - recoil)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and took %d in return" % [damage, recoil])
		await self.textbox_closed
	else:
		$BigHit.play()
		current_enemy_health = max(0, current_enemy_health - damage)
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		current_player_health = max(1, current_player_health - recoil)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		display_text("You dealt %d and took %d in return" % [damage, recoil])
		await self.textbox_closed
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("You hit with a savage crit dealing %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("Your swing missed and you deal no damage")
		await self.textbox_closed
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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
		set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		display_text("You dealth %d damage!" % damage)
		await self.textbox_closed
	else:
		display_text("You failed to cast the spell")
		await self.textbox_closed
		turn += 1
		enemy_turn()
	if current_enemy_health == 0:
		PlayerState.boss3 = true
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


