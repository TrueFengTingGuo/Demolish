extends Panel

onready var dialogue_player = $Dialogue_Player
const button_instance = preload("res://Scenes/DialogueSystem/dialogue_decision_button.tscn")
signal on_next_conversation(nextConversation_index)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_player.start()
	dialogue_player.dialogue_start()
	
	$Name.text = dialogue_player.current_name_who_talk
	$Container/Text.text = dialogue_player.current_text
	
	add_new_decisions()
		

func add_new_decisions():
	for decision in dialogue_player.current_decisions:
		var arrow_instnace = button_instance.instance()
		arrow_instnace.next_conversation = dialogue_player.current_decisions.get(decision)
		arrow_instnace.connect("on_next_conversation",self,"handle_on_next_conversation")
		arrow_instnace.text = decision
		$Container.add_child(arrow_instnace)
		


func handle_on_next_conversation(nextConversation_index):
	print("???")
	dialogue_player.dialogue_next(nextConversation_index)
	for child in $Container.get_children():
		if child.is_in_group("Button"):
			child.queue_free()
	add_new_decisions()
	
