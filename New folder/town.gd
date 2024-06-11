extends Node2D

var current_gold = 0
var level = PlayerState.level
var requiredgold = 100 + (level * 100)
# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerState.first_load == true:
		$Player.position = Vector2(800,520)
		PlayerState.first_load = false
	else:
		$Player.position = PlayerState.pos
	$Player/Camera2D/Level_up.hide()
	$Player/Camera2D/Armor.hide()
	$Player/Camera2D/Weapon.hide()
	$Player/Camera2D/save.hide()
	current_gold = PlayerState.gold
	set_gold($Player/Camera2D/Level_up/Stats, current_gold)
	set_stats($Player/Camera2D/Level_up/Stats)
	$Music.play()
	$Player/Camera2D/Menu.hide()
	set_health()
	set_mana()
	set_damage()

func set_gold(Have, gold):
	Have.get_node("Have").text = "Gold: %d" % [gold]
func set_damage():
	PlayerState.damage = (PlayerState.base_damage * (1 +(PlayerState.strength * .1)))
func set_magic():
	PlayerState.magic = (PlayerState.base_magic * (1 +(PlayerState.intelligence * .2)))
func set_health():
	PlayerState.max_health = (PlayerState.base_health * (1 +(PlayerState.endurance * .4)))
	PlayerState.current_health = PlayerState.max_health
func set_mana():
	PlayerState.max_mana = (PlayerState.base_mana * (1 +(PlayerState.Insight * .2)))
	PlayerState.current_mana = PlayerState.max_mana
func set_crit():
	PlayerState.crit = 5 + (3 * PlayerState.luck) + (1 * PlayerState.dexterity)

func set_stats(stats):
	var requiredgold = 100 + (PlayerState.level * 100)
	stats.get_node("Str").get_node("Str_dis").text = "%d" % [PlayerState.strength]
	stats.get_node("Dex").get_node("Dex_dis").text = "%d" % [PlayerState.dexterity]
	stats.get_node("Int").get_node("Int_dis").text = "%d" % [PlayerState.intelligence]
	stats.get_node("End").get_node("End_dis").text = "%d" % [PlayerState.endurance]
	stats.get_node("Luck").get_node("Luck_dis").text = "%d" % [PlayerState.luck]
	stats.get_node("Ins").get_node("Ins_dis").text = "%d" % [PlayerState.Insight]
	stats.get_node("Required").text = "Gold Required: %d" % [requiredgold]
	
func set_weapon_store(weapon):
	set_gold($Player/Camera2D/Weapon/Shop, current_gold)
	if PlayerState.Sword_1 == 0:
		$Player/Camera2D/Weapon/Shop/Sword_1/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Sword_1/Label.show()
	if PlayerState.Sword_2 == 0:
		$Player/Camera2D/Weapon/Shop/Sword_2/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Sword_2/Label.show()
	if PlayerState.Sword_3 == 0:
		$Player/Camera2D/Weapon/Shop/Sword_3/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Sword_3/Label.show()

	if PlayerState.Staff_1 == 0:
		$Player/Camera2D/Weapon/Shop/Staff_1/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Staff_1/Label.show()
	if PlayerState.Staff_2 == 0:
		$Player/Camera2D/Weapon/Shop/Staff_2/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Staff_2/Label.show()
	if PlayerState.Staff_3 == 0:
		$Player/Camera2D/Weapon/Shop/Staff_3/Label.hide()
	else: 
		$Player/Camera2D/Weapon/Shop/Staff_3/Label.show()


func set_armor_store(armor):
	set_gold($Player/Camera2D/Weapon/Shop, current_gold)
	if PlayerState.Armor_1 == 0:
		$Player/Camera2D/Armor/Shop/Armor_1/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Armor_1/Label.show()
	if PlayerState.Armor_2 == 0:
		$Player/Camera2D/Armor/Shop/Armor_2/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Armor_2/Label.show()
	if PlayerState.Armor_3 == 0:
		$Player/Camera2D/Armor/Shop/Armor_3/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Armor_3/Label.show()

	if PlayerState.Ring_1 == 0:
		$Player/Camera2D/Armor/Shop/Ring_1/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Ring_1/Label.show()
	if PlayerState.Ring_2 == 0:
		$Player/Camera2D/Armor/Shop/Ring_2/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Ring_2/Label.show()
	if PlayerState.Ring_3 == 0:
		$Player/Camera2D/Armor/Shop/Ring_3/Label.hide()
	else:
		$Player/Camera2D/Armor/Shop/Ring_3/Label.show()

#level up tower menu
func _on_tower_body_entered(body):
	$Player/Camera2D/Level_up.show()
	$Player/Camera2D/Menu.hide()
	set_stats($Player/Camera2D/Level_up/Stats)
	set_gold($Player/Camera2D/Level_up/Stats, current_gold)
func _on_tower_body_exited(body):
	$Player/Camera2D/Level_up.hide()
func _on_level_up_close_requested():
	$Player/Camera2D/Level_up.hide()

func _on_str_pressed():
	if current_gold >= requiredgold and PlayerState.strength <= 9:
		PlayerState.strength += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_damage()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
func _on_dex_pressed():
	if current_gold >= requiredgold and PlayerState.dexterity <= 9:
		PlayerState.dexterity += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_crit()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
func _on_int_pressed():
	if current_gold >= requiredgold and PlayerState.intelligence <= 9:
		PlayerState.intelligence += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_magic()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
func _on_end_pressed():
	if current_gold >= requiredgold and PlayerState.endurance <= 9:
		PlayerState.endurance += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_health()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
func _on_luck_pressed():
	if current_gold >= requiredgold and PlayerState.luck <= 9:
		PlayerState.luck += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_crit()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
func _on_ins_pressed():
	if current_gold >= requiredgold and PlayerState.Insight <= 9:
		PlayerState.Insight += 1
		PlayerState.level += 1
		current_gold -= requiredgold
		PlayerState.gold = current_gold
		requiredgold = 100 + (PlayerState.level * 100)
		set_mana()
		set_gold($Player/Camera2D/Level_up/Stats, current_gold)
		set_stats($Player/Camera2D/Level_up/Stats)
	
	
#armor shop menu
func _on_armor_body_entered(body):
	$Player/Camera2D/Menu.hide()
	$Player/Camera2D/Armor.show()
	set_armor_store($Player/Camera2D/Armor/Shop)
	set_gold($Player/Camera2D/Armor/Shop, current_gold)
func _on_armor_body_exited(body):
	$Player/Camera2D/Armor.hide()
func _on_armor_close_requested():
	$Player/Camera2D/Armor.hide()
	
func _on_armor_1_pressed():
	if current_gold >= 500 and PlayerState.Armor_1 == 0:
		PlayerState.Armor_1 = 1
		current_gold -= 500
		PlayerState.gold = current_gold
		PlayerState.base_health += 50
		set_health()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)
func _on_armor_2_pressed():
	if current_gold >= 2000 and PlayerState.Armor_2 == 0 and PlayerState.Armor_1 == 1:
		PlayerState.Armor_2 = 1
		current_gold -= 2000
		PlayerState.gold = current_gold
		PlayerState.base_health += 100
		set_health()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)
func _on_armor_3_pressed():
	if current_gold >= 6000 and PlayerState.Armor_3 == 0 and PlayerState.Armor_2 == 1:
		PlayerState.Armor_3 = 1
		current_gold -= 6000
		PlayerState.gold = current_gold
		PlayerState.base_health += 150
		set_health()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)

func _on_ring_1_pressed():
	if current_gold >= 1500 and PlayerState.Ring_1 == 0:
		PlayerState.Ring_1 = 1
		current_gold -= 1500
		PlayerState.gold = current_gold
		PlayerState.base_mana += 20
		set_mana()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)
func _on_ring_2_pressed():
	if current_gold >= 5000 and PlayerState.Ring_2 == 0 and PlayerState.Ring_1 == 1:
		PlayerState.Ring_2 = 1
		current_gold -= 5000
		PlayerState.gold = current_gold
		PlayerState.base_mana += 40
		set_mana()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)
func _on_ring_3_pressed():
	if current_gold >= 20000 and PlayerState.Ring_3 == 0 and PlayerState.Ring_2 == 1:
		PlayerState.Ring_3 = 1
		current_gold -= 20000
		PlayerState.gold = current_gold
		PlayerState.base_mana += 60
		set_mana()
		set_gold($Player/Camera2D/Armor/Shop, current_gold)
		set_armor_store($Player/Camera2D/Armor/Shop)


#Weapon Shop menu
func _on_weapon_body_entered(body):
	$Player/Camera2D/Weapon.show()
	$Player/Camera2D/Menu.hide()
	set_weapon_store($Player/Camera2D/Weapon/Shop)
	set_gold($Player/Camera2D/Weapon/Shop, current_gold)
func _on_weapon_body_exited(body):
	$Player/Camera2D/Weapon.hide()
func _on_weapon_close_requested():
	$Player/Camera2D/Weapon.hide()

func _on_sword_1_pressed():
	if current_gold >= 1000 and PlayerState.Sword_1 == 0:
		PlayerState.Sword_1 = 1
		current_gold -= 1000
		PlayerState.gold = current_gold
		PlayerState.base_damage += 10
		set_damage()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)
func _on_sword_2_pressed():
	if current_gold >= 3000 and PlayerState.Sword_2 == 0 and PlayerState.Sword_1 == 1:
		PlayerState.Sword_2 = 1
		current_gold -= 3000
		PlayerState.gold = current_gold
		PlayerState.base_damage += 20
		set_damage()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)
func _on_sword_3_pressed():
	if current_gold >= 9000 and PlayerState.Sword_3 == 0 and PlayerState.Sword_2 == 1:
		PlayerState.Sword_3 = 1
		current_gold -= 9000
		PlayerState.gold = current_gold
		PlayerState.base_damage += 30
		set_damage()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)
	
func _on_staff_1_pressed():
	if current_gold >= 2000 and PlayerState.Staff_1 == 0:
		PlayerState.Staff_1 = 1
		current_gold -= 2000
		PlayerState.gold = current_gold
		PlayerState.base_magic += 15
		set_magic()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)
func _on_staff_2_pressed():
	if current_gold >= 6000 and PlayerState.Staff_2 == 0 and PlayerState.Staff_1 == 1:
		PlayerState.Staff_2 = 1
		current_gold -= 6000
		PlayerState.gold = current_gold
		PlayerState.base_magic += 30
		set_magic()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)
func _on_staff_3_pressed():
	if current_gold >= 15000 and PlayerState.Staff_3 == 0 and PlayerState.Staff_2 == 1:
		PlayerState.Staff_3 = 1
		current_gold -= 15000
		PlayerState.gold = current_gold
		PlayerState.base_magic += 45
		set_magic()
		set_gold($Player/Camera2D/Weapon/Shop, current_gold)
		set_weapon_store($Player/Camera2D/Weapon/Shop)


#func _on_area_2d_body_entered(body):
	#get_tree().change_scene_to_file("res://fight_screen_mob.tscn")
	#PlayerState.pos = $Player.position
	#$Player/Camera2D/Window.show()


func _on_cave_body_entered(body):
	print(PlayerState.boss1)
	print("1")
	print(PlayerState.boss2)
	print ("2")
	print(PlayerState.boss3)
	print("3")
	print(PlayerState.boss4)
	print("4")
	
	PlayerState.current_health = PlayerState.max_health
	PlayerState.current_mana = PlayerState.max_mana
	PlayerState.pos = Vector2(450,625)
	$Music.stop()
	
	print(PlayerState.boss1)
	print("1")
	print(PlayerState.boss2)
	print ("2")
	print(PlayerState.boss3)
	print("3")
	print(PlayerState.boss4)
	print("4")
	if PlayerState.boss2:
		PlayerState.scene = "res://dungeon/floor 3/D_3_F_1_R_1.tscn"
		get_tree().change_scene_to_file("res://dungeon/floor 3/D_3_F_1_R_1.tscn")
	elif PlayerState.boss1:
		PlayerState.scene = "res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn"
		get_tree().change_scene_to_file("res://dungeon/floor2/Dungeon_2_ floor_1_room_1.tscn")
	else:
		PlayerState.scene = "res://dungeon/Dungeon_Floor_1_room_1.tscn"
		get_tree().change_scene_to_file("res://dungeon/Dungeon_Floor_1_room_1.tscn")
	

func _on_window_close_requested():
	$Player/Camera2D/Window.hide()



func _unhandled_key_input(event):
	if Input.is_action_just_pressed("Open_menu"):
			$Player/Camera2D/Menu.show()
			$Player/Camera2D/Menu/Panel/Level.text = "Level - %d" % [PlayerState.level]
			$Player/Camera2D/Menu/Panel/Health.text = "health - %d / %d" % [PlayerState.current_health, PlayerState.max_health]
			$Player/Camera2D/Menu/Panel/Mana.text = "Mana - %d / %d" % [PlayerState.current_mana, PlayerState.max_mana]
			$Player/Camera2D/Menu/Panel/Phys_Damage.text = "Attack Damage   %d - %d" % [round(PlayerState.damage * .8 + (.04 * PlayerState.dexterity)),round(PlayerState.damage * 1.2 + (.1 * PlayerState.dexterity))]
			$Player/Camera2D/Menu/Panel/Magic_Damage.text = "Magic Damage   %d - %d" %[round(PlayerState.magic * 1),round(PlayerState.magic * 2)]
			$Player/Camera2D/Menu/Panel/Str.text = "Strength - %d" % PlayerState.strength
			$Player/Camera2D/Menu/Panel/Dex.text = "Dexterity - %d" % PlayerState.dexterity
			$Player/Camera2D/Menu/Panel/Int.text = "Intelligence - %d" % PlayerState.intelligence
			$Player/Camera2D/Menu/Panel/End.text = "Endurance - %d" % PlayerState.endurance
			$Player/Camera2D/Menu/Panel/Ins.text = "Insight - %d" % PlayerState.Insight
			$Player/Camera2D/Menu/Panel/Luck.text = "Luck - %d" % PlayerState.luck
			$Player/Camera2D/Menu/Panel/Gold.text = "Gold - %d" % PlayerState.gold





func _on_menu_close_requested():
	$Player/Camera2D/Menu.hide()


func _on_save_body_entered(body):
	$Player/Camera2D/save.show()


func _on_save_body_exited(body):
	$Player/Camera2D/save.hide()


func _on_save_close_requested():
	$Player/Camera2D/save.hide()
