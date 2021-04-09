extends Node2D

onready var COIN = preload("res://Scenes/Coin.tscn")


func spawn_coin():
	var coin_instance = COIN.instance()	
	get_parent().add_child(coin_instance)
	coin_instance.global_position = self.global_position
