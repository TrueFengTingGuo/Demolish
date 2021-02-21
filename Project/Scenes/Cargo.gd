extends RigidBody2D

var coin_instance
var numberOfCoin = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var path = "res://Scenes/Coin.tscn"
	coin_instance = load(path)


func on_grabed(impluse):
	var offset = Vector2(0,0)
	
	apply_impulse(offset,15* impluse)
	
func on_destroy():
	
	for number in numberOfCoin:

		var new_instance = coin_instance.instance()
		get_parent().add_child(new_instance)
		

func _on_Cargo_body_entered(body):
	pass # Replace with function body.
