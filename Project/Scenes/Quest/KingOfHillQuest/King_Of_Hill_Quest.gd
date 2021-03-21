extends "res://Scenes/Quest/Quest_template.gd"

#used to display info about quest in UI
const INFO_PANEL = preload("res://Scenes/Quest/Quest_Info_Display_UI.tscn")

#this quest's value
var enemy_number = 0
var enemy_spawning_point = []
var cargos_spawning_nodes = []
var current_total_enemy_number = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	current_total_enemy_number = 0
	for child in self.get_children():					
		if child.is_in_group("Enemy_Spawning_Point"):	
			enemy_number += child.enemy_number
			enemy_spawning_point.append(child)
	
	#create info for cargo
	var info_instnace_enemy = INFO_PANEL.instance()
	info_instnace_enemy.create_new_collecting("Kill All Enemy",0,enemy_number)
	quest_info["Kill All Enemy"] = info_instnace_enemy

	#create info for enemy
	var info_instnace_NPC = INFO_PANEL.instance()
	info_instnace_NPC.create_new_goal("NPC Is Safe")
	quest_info["NPC Is Safe"] = info_instnace_NPC
	

func _physics_process(delta):
	
	#active the quest by player reach to the npc
	if $King_Of_Hill_NPC.see_player_enter:
		quest_active = true
		get_node("/root/Game").change_active_quest(self)
		
	if quest_active:
		#active spawning enemies
		for point in enemy_spawning_point:
			point.active = true	
			
		#check quest rule
		quest_rule()
		
		#update quest info
		current_total_enemy_number = 0
		for child in self.get_children():					
			if child.is_in_group("Enemy_Spawning_Point"):	
				current_total_enemy_number += child.how_many_enemy()

		quest_info["Kill All Enemy"].update_collecting(current_total_enemy_number)
		quest_info["NPC Is Safe"].update_goal(!$King_Of_Hill_NPC.check_nearby_enemy())

	if quest_completed:
		$King_Of_Hill_NPC.task_completed = true			
		spawn_coins()
	
func quest_rule():
	
				
	if current_total_enemy_number == 0 and !$King_Of_Hill_NPC.check_nearby_enemy():
		
		#check how many enemy needs to spawn
		var how_many_left_to_spawn = 0	
		for child in self.get_children():					
			if child.is_in_group("Enemy_Spawning_Point"):	
				how_many_left_to_spawn += child.how_many_left_to_spawn()
				
		#if all enemy are spawned, check the rule see the task is completed
		if how_many_left_to_spawn == 0:
			for point in enemy_spawning_point:
				point.active = false
			quest_completed = true
