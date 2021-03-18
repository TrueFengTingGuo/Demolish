extends TextureProgress

onready var parentNode = get_parent()
var current_hp = 0
var previous_hp = 0
var totalOffset = 0
export var hp_changingSpeed = 3 #each frame will decrease the offset by the amount
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = parentNode.hp
	previous_hp = parentNode.hp
	
	#calcualte the progress bar value
	if(parentNode._init_hp == 0):
		self.value = 100
		return
	self.value = int(float(current_hp)/parentNode._init_hp *100)

func _process(delta):
	
	if(previous_hp != parentNode.hp):
		var current_offset = parentNode.hp - previous_hp

		totalOffset += current_offset
		previous_hp = parentNode.hp		
	
	#if there is still offset needs add to the value of progress bar
	if abs(totalOffset) > 0.0001:
		
		current_hp += totalOffset * hp_changingSpeed * delta
		totalOffset -= totalOffset * hp_changingSpeed * delta	
		self.value = int(float(current_hp)/parentNode._init_hp *100)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
