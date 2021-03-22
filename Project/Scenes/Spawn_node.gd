extends Node2D


var randomNumberGenerator  

export (String,"Warrior","Ranger","Healer") var spawn_type = "Warrior"
export var enemy_number = 1
export var _init_spawning_time = 3
export var active = false
var current_spawning_time = 0
var numberOf_enemy = 0


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

	var not_exist = true
	for child in get_children():
		if child.is_in_group(spawn_type):
			not_exist = false

	#when current_spawning_time goes to 0, spawn an enemy
	current_spawning_time -= _delta
	numberOf_enemy = get_child_count() -1
		
	if enemy_number > 0 :
		if current_spawning_time < 0:
			current_spawning_time = _init_spawning_time
			$AnimatedSprite.frame = 0
			$AnimatedSprite.play("Spwan")

			var new_instance = _instance.instance()
			add_child(new_instance)
			enemy_number -= 1

func how_many_enemy():
	return numberOf_enemy

func how_many_left_to_spawn():
	return enemy_number
