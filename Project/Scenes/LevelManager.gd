extends Node2D

onready var playerObject = $Player

var quest_is_active = false
var active_quest = null
var coin = 0
# Called when the node enters the scene tree for the first time.

func _init():
	GlobalAccess.lvlManager = self

func _ready():
	
	$UI/Gold_Count.text =  "X " + String(coin)
	
	
func _physics_process(delta):
	#update the hp of player in UI
	$UI.change_player_hp($Player.hp)

func change_active_quest(quest):
	if active_quest == quest:
		return
	
	if active_quest != null:
		active_quest.quest_active = false
	active_quest = quest
	quest_is_active = active_quest.quest_active
	$UI.add_infos_about_quest(active_quest.quest_info)
	print("add")

func _on_coin_collected():
	coin += 1
	_ready()

