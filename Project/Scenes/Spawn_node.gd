extends Node2D


var randomNumberGenerator  

export var spawn_type = "Warrior"
export var enemy_number = 1
export var _init_spawning_time = 3
var current_spawning_time = 0
export var active = false


var warrior_instance
var warrior_instance_timer

var ranger_instance
var ranger_instance_timer

var _instance
var _instance_timer

func _ready():
	randomNumberGenerator = RandomNumberGenerator.new()
	
	var path = "res://Scenes/Enemies/" + spawn_type + ".tscn"
	_instance = load(path)
	
	current_spawning_time = _init_spawning_time
	#warrior_instance = load("res://Scenes/Warrior.tscn")
	#ranger_instance = load("res://Scenes/Ranger.tscn")
	#enemy_number = randomNumberGenerator.randi_range (100,200)

func  _physics_process(_delta: float) -> void:
	
	if not active:
		
		return
	#warrior_instance_timer += _delta
	#$AnimatedSprite.play("Idle")
	var not_exist = true
	for child in get_children():
		if child.is_in_group(spawn_type):
			not_exist = false

	
#	if not_exist:
#		$AnimatedSprite.frame = 0
#		$AnimatedSprite.play("Spwan")
#
#		var new_instance = _instance.instance()
#		add_child(new_instance)

	#when current_spawning_time goes to 0, spawn an enemy
	current_spawning_time -= _delta
	
		
	if enemy_number > 0 :
		if current_spawning_time < 0:
			current_spawning_time = _init_spawning_time
			$AnimatedSprite.frame = 0
			$AnimatedSprite.play("Spwan")

			var new_instance = _instance.instance()
			add_child(new_instance)
			enemy_number -= 1

