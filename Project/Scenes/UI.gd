extends CanvasLayer

var coin = 0
var hp = 0
var _init_hp = 100
func _ready():
	
	$Gold_Count.text =  "X " + String(coin)
	

func _on_coin_collected():
	coin += 1
	_ready()

func change_player_hp(current_hp):
	hp = current_hp

func change_player_init_hp(current_hp):
	_init_hp = current_hp
