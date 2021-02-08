extends KinematicBody2D

var velocity = Vector2(0,0)
func _ready():
	pass
#grab by player
func on_grabed(force):
	velocity += force
