extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_conversation = 0




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():

	emit_signal("on_next_conversation", next_conversation)
