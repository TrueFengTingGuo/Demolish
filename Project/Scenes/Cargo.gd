extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_grabed(impluse):
	var offset = Vector2(0,0)

	apply_impulse(offset,15* impluse)


func _on_Cargo_body_entered(body):
	pass # Replace with function body.
