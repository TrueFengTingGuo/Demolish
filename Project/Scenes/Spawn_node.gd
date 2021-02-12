extends Node2D


var randomNumberGenerator  

export var spawn_type = "Warrior"
export var warrior_number = 20

var warrior_instance
var warrior_instance_timer

var ranger_instance
var ranger_instance_timer

var _instance
var _instance_timer

func _ready():
	randomNumberGenerator = RandomNumberGenerator.new()
	
	var path = "res://Scenes/" + spawn_type + ".tscn"
	_instance = load(path)
	
	#warrior_instance = load("res://Scenes/Warrior.tscn")
	#ranger_instance = load("res://Scenes/Ranger.tscn")
	#warrior_number = randomNumberGenerator.randi_range (100,200)

func  _physics_process(_delta: float) -> void:
	
	#warrior_instance_timer += _delta
	#$AnimatedSprite.play("Idle")
	var not_exist = true
	for child in get_children():
		if child.is_in_group(spawn_type):
			not_exist = false

	if not_exist:
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play("Spwan")

		var new_instance = _instance.instance()
		add_child(new_instance)
	
	"""	
	if warrior_number > 0 :
		var new_warrior = warrior_instance.instance()
		add_child(new_warrior)
		warrior_number -= 1
	"""
