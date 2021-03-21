extends "res://Scenes/Quest/Quest_template.gd"

#used to display info about quest in UI
const INFO_PANEL = preload("res://Scenes/Quest/Quest_Info_Display_UI.tscn")

#this quest's value
var numOfCargo = 0
var enemy_number = 0
var enemy_spawning_point = []
var cargos_spawning_nodes = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	for child in self.get_children():
		
		if child.is_in_group("Cargo_spawning_node"):
			
			cargos_spawning_nodes.append(child)
			numOfCargo += child.cargot_num
						
		elif child.is_in_group("Enemy_Spawning_Point"):	
			enemy_number += child.enemy_number
			enemy_spawning_point.append(child)

	#create info for cargo
	var info_instnace_cargo = INFO_PANEL.instance()
	info_instnace_cargo.create_new_collecting("Collect All Cargo",0,numOfCargo)
	quest_info["Collect All Cargo"] = info_instnace_cargo

	#create info for enemy
	var info_instnace_enemy = INFO_PANEL.instance()
	info_instnace_enemy.create_new_goal("NPC Is Safe",false)
	quest_info["NPC Is Safe"] = info_instnace_enemy
	

func _physics_process(delta):
	
	#active the quest by player reach to the npc
	if $Cargo_NPC.see_player_enter:
		quest_active = true
		get_node("/root/Game").change_active_quest(self)
	if quest_active:
		#active spawning enemies
		for point in enemy_spawning_point:
			point.active = true
		
		#active spawning cargos
		for node in cargos_spawning_nodes:
			node.active = true
			
		#check quest rule
		quest_rule()
		
		#update quest info
		quest_info["Collect All Cargo"].update_collecting($Cargo_NPC.cargo_count)
		quest_info["NPC Is Safe"].update_goal($Cargo_NPC.npc_is_safe)

	if quest_completed:
		$Cargo_NPC.task_completed = true	
		
		spawn_coins()
	
func quest_rule():
	if $Cargo_NPC.cargo_count == numOfCargo:
		for point in enemy_spawning_point:
			point.active = false
			$Cargo_NPC.check_nearby_enemy()
	if $Cargo_NPC.cargo_count == numOfCargo and $Cargo_NPC.npc_is_safe:
		quest_completed = true
