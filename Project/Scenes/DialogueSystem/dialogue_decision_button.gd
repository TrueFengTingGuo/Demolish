extends Button

signal on_next_conversation(nextConversation_index)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_conversation = 0

func _on_Button_pressed():

	emit_signal("on_next_conversation", int(next_conversation))
