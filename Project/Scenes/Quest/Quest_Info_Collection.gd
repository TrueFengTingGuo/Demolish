extends VBoxContainer

var info_container = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_infos():
	#display all infos in the UI
	if info_container.empty():
		return
		
	for info in info_container:
		self.add_child(info_container[info])

func clean_infos():
	for child in get_children():
		self.remove_child(child)
