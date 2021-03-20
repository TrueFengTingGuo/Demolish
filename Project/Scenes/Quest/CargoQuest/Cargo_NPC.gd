extends Node2D
signal startThisConverstion(conversation_jason_file_path)
signal endThisConversation()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cargo_count = 0
var animation_state_machine
var see_cargo_enter = false
var see_cargo_leave = false
var see_player_enter = false
var task_completed = false
var npc_is_safe = true
const jason_file_for_conversation = "res://Scenes/DialogueSystem/Dialogues.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_state_machine =$AnimationTree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	
	if not see_cargo_enter and not see_cargo_leave:
		animation_state_machine.travel("Idle")
	elif see_cargo_enter:
		see_cargo_enter = false
		animation_state_machine.travel("Completion")
		
	elif see_cargo_leave:
		see_cargo_leave = false
		animation_state_machine.travel("Cargo_not_inside")
		
	if task_completed:
		$Character_dialog.text = "THANK YOU"
		
		
func check_nearby_enemy():
	npc_is_safe = true
	for body in $Area2D2.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			npc_is_safe = false
			$Character_dialog.text = "I am not safe"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Cargo"):
		cargo_count += 1
		see_cargo_enter = true
		$Character_dialog.text = "I got the cargo"
		
	elif body.is_in_group("Player"):
		see_player_enter = true
		emit_signal("startThisConverstion",jason_file_for_conversation)
		#$Character_dialog.text = "Help me find all the cargo"

func _on_Area2D_body_exited(body):
	if body.is_in_group("Cargo"):
		cargo_count -= 1
		see_cargo_leave = true
		$Character_dialog.text = "Please bring that back"

	elif body.is_in_group("Player"):
		see_player_enter = false
		emit_signal("endThisConversation")

		
func _on_Area2D2_body_entered(body):
	if body.is_in_group("Enemy"):
		npc_is_safe = false
		$Character_dialog.text = "I don't feel safe"

func _on_Area2D2_body_exited(body):
	if body.is_in_group("Enemy"):
		npc_is_safe = true
		$Character_dialog.text = "I am safe"
