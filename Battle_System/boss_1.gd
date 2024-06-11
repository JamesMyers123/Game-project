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
var charge = 0
var E_charge = 0
var buff = 0 
var gold = 0

func _ready():
	enemy = load("res://Battle/Boss_1_Buff.tres")
	current_player_health = PlayerState.current_health
	current_player_mana = PlayerState.current_mana
	current_enemy_health = enemy.health * (1 + PlayerState.NG * .2)
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

#every even turn the boss will gain a 5% damage buff
#every 3rd turn the boss will life strike healing based off damage dealt
#every 7th,8th and 9th turn the boss will do a charge unleash it on the 10th turn for 3x damage
func enemy_turn():
	$Spells.hide()
	$ActionsPanel.hide()
	print(turn)
	var Ehit = (rng.randi_range(10,20) * (1 + (PlayerState.NG * .2)))
	
	if (turn % 7) == 0 or E_charge > 0 and E_charge != 3:
		E_charge += 1
		display_text("The [Boss_1] Charges up for a big attack")
		await self.textbox_closed
		is_defending = false
	elif E_charge == 3:
		display_text("The [Boss_1] unleashes its charge")
		await self.textbox_closed
		E_charge = 0
		if is_defending:
			is_defending = false
			var damage = (Ehit * 3) / 4
			$BlockHit.play()
			display_text("The [Boss_1] deals %d damage past your guard" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		else:
			var damage = (Ehit * 3)
			$BigHit.play()
			display_text("The [Boss_1] deals %d damage to you" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	elif (turn % 3) == 0 and E_charge == 0:
		if is_defending:
			is_defending = false
			var  damage = (Ehit *.8) /4
			display_text("The [Boss_1] thrusts its sword with vamperic energy")
			await self.textbox_closed
			$BlockHit.play()
			$heal.play()
			display_text("The [Boss_1] deals %d past your guard and heals itsles for %d" % [damage, damage/2])
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			current_enemy_health = min(enemy.health, current_enemy_health + damage / 2)
			set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
		else:
			var  damage = Ehit *.8
			display_text("The [Boss_1] thrusts its sword with vamperic energy")
			await self.textbox_closed
			$Hit.play()
			$heal.play()
			display_text("The [Boss_1] deals %d damage to you and heals itsles for %d" % [damage, damage/2])
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
			current_enemy_health = min(enemy.health, current_enemy_health + damage / 2)
			set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	elif (turn % 2) == 0 and E_charge == 0:
		is_defending = false
		display_text("The [Boss_1]'s anger grows")
		await self.textbox_closed
		buff += .05
	else:
		if is_defending:
			is_defending = false
			var damage = Ehit / 4
			$BlockHit.play()
			display_text("The [Boss_1] deals %d damage past your guard" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
		else:
			var damage = Ehit
			$Hit.play()
			display_text("The [Boss_1] deals %d damage to you" % damage)
			await self.textbox_closed
			current_player_health = max(0, current_player_health - damage)
			set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, PlayerState.max_health)
	if current_player_health == 0:
		display_text("You were slain")
		await self.textbox_closed
		set_player_state()
		PlayerState.pos = Vector2(800,520)
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://town.tscn")
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
		PlayerState.boss1 = true
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
		PlayerState.boss1 = true
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
		PlayerState.boss1 = true
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
		PlayerState.boss1 = true
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
	damage = damage * enemy.firevuln
	if current_player_mana >= 10:
		$FireBall.play()
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
		PlayerState.boss1 = true
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
	damage = damage * enemy.icevuln
	if current_player_mana >= 10:
		$FrostBolt.play()
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
		PlayerState.boss1 = true
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
	damage = damage * enemy.lightningvuln
	if current_player_mana >= 10:
		$LightningBolt.play()
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
		PlayerState.boss1 = true
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
		PlayerState.boss1 = true
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


