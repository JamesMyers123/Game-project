extends Node
#This script keeps track of the player. 
#level
var level = 0            #current level tracker
var NG = 0 
#combat Dynamic
var current_health = 100  #current health tracker
var current_mana = 20     #current mana tracker
var gold = 1000         #current gold tracker

#Stat/item dependent
var base_health = 100
var base_mana = 20
var base_damage = 10
var base_magic = 10
var max_health = 100 #base health increased with items and multiplied by endurance 
var max_mana = 20   #base mana increased with items and multiplied with Insight
var crit = 5         #base crit scaled by luck
var _range = 0        #hold out from when daggers were in the game now dictated by dex
var magic = 10       #base strength of magic increased increased with items
var damage = 10      #Base strength of weapon increased with items

#stats
var strength = 0     #increased damage by .15 per level up to 2x (1+(str*.1))
var dexterity = 0    #improved damage range. Low(.8+(Dex*.08)) High(1.2+(Dex*.15)) also crit by 2% per level
var intelligence = 0 #improved Magic damage by .3 per level up to 4x (1+(Int*.2))
var endurance = 0    #improve max life by .5 per level up to 5X (1+(end*.5))
var Insight = 0      #improve max mana by .5 per level up to 5X (1+(end*.5))
var luck = 0         #improve crit rate by 3% per level up to 35% adn gold income by 10% per level up to 100%

#Weapon upgrades for the game to remember what weapons the player has
#Increase base damage 
var Sword_1 = 0 # 20 Gold cost 1000
var Sword_2 = 0 # 50 Gold cost 3000
var Sword_3 = 0 # 70 Gold cost 9000
#Increases base magic damage
var Staff_1 = 0 # 30 Gold cost 2000
var Staff_2 = 0 # 60 Gold cost 6000
var Staff_3 = 0 # 80 Gold cost 15000

#Armor upgrades
#Increases base health
var Armor_1 = 0 #150 Gold cost 500
var Armor_2 = 0 #200 Gold cost 2000
var Armor_3 = 0 #300 Gold cost 6000
#Increases bae Mana
var Ring_1 = 0 #30  Gold cost 1500
var Ring_2 = 0 #50  Gold cost 5000
var Ring_3 = 0 #100 Gold cost 20000

var boss1 = false
var boss2 = false
var boss3 = false
var boss4 = false
#player position data
var first_load = true
var pos = Vector2(800,520)
var scene = "res://town.tscn"



#development variables ignore them 
var mob = "res://Battle/Zombie.tres"




