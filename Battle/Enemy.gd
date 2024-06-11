extends Resource

#base enemy stats and info
@export var name: String = "Enemy"
@export var texture: Texture2D= null
@export var health: int = 100 
@export var damage: int = 5
@export var firevuln: float = 1 #1.2 means 20% more damage
@export var lightningvuln: float = 1
@export var icevuln: float = 1 

#Specal Move stats
@export var Move_name: String = "name"
@export var Move_type: int = 0 # 1-Insant attack 2-windup attack 3-heal/degen 4-bezerker strike
@export var Move_damage: float = 1 #1.1 = 10% multiplier
@export var Move_heal: int = 0 #only used for type 3 and 4
@export var Chance: int = 50 #percentage chance for the move to be selected. 0 if there is not an attack
#gold drop
@export var gold = 100
