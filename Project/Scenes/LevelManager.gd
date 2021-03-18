extends Node2D

onready var playerObject = $Player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _init():
	GlobalAccess.lvlManager = self

func _physics_process(delta):
	#update the hp of player in UI
	$UI.change_player_hp($Player.hp)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
