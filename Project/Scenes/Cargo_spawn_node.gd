extends Node2D


export var cargot_num = 1
export var active = false

var _instance

# Called when the node enters the scene tree for the first time.
func _ready():

	
	var path = "res://Scenes/Cargo.tscn"
	_instance = load(path)



func  _physics_process(_delta: float) -> void:
	if cargot_num > 0 and active:
		var new_instance = _instance.instance()
		
		get_parent().add_child(new_instance)
		new_instance.global_position = self.global_position
		cargot_num -=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
