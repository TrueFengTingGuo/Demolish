extends CanvasLayer

var coin = 0

func _ready():
	

	$Gold_Count.text =  "X " + String(coin)


func _on_coin_collected():
	coin += 1
	_ready()



