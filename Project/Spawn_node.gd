extends Node2D


var randomNumberGenerator  

export var warrior_number = 20
var warrior_instance
var warrior_instance_timer

func _ready():
	randomNumberGenerator = RandomNumberGenerator.new()
	warrior_instance = load("res://Scenes/Warrior.tscn")
	warrior_number = randomNumberGenerator.randi_range (100,200)

func  _physics_process(_delta: float) -> void:
	
	#warrior_instance_timer += _delta
	#$AnimatedSprite.play("Idle")
	var no_warrior = true
	for child in get_children():
		if child.is_in_group("Warrior"):
			no_warrior = false

	if no_warrior:
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play("Spwan")

		var new_warrior = warrior_instance.instance()
		add_child(new_warrior)
	
	"""	
	if warrior_number > 0 :
		var new_warrior = warrior_instance.instance()
		add_child(new_warrior)
		warrior_number -= 1
	"""
