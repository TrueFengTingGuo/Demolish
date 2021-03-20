extends Node2D

const COIN = preload("res://Scenes/Coin.tscn")
var quest_active = false
var quest_completed = false
var quest_info = {}
export var coin_num = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func quest_rule():
	pass
	
func spawn_coins():
	for count in coin_num:		
		var coin = COIN.instance()
		coin.global_position = self.global_position
		get_node("/root/Game").add_child(coin)
	coin_num = 0
