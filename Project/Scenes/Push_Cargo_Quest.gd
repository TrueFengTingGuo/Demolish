extends Node2D

var numOfCargo = 0
var enemy_spawning_point = []
var cargos_spawning_nodes = []
var quest_active = false
var quest_completed = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	for child in self.get_children():
		if child.is_in_group("Cargo_spawning_node"):
			cargos_spawning_nodes.append(child)
			numOfCargo += child.cargot_num
		elif child.is_in_group("Enemy_Spawning_Point"):	
			enemy_spawning_point.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	
	#active the quest by player reach to the npc
	if $Cargo_NPC.see_player_enter:
		quest_active = true
		
	if quest_active:
		for point in enemy_spawning_point:
			point.active = true
			
		for node in cargos_spawning_nodes:
			node.active = true
			
	if quest_completed:
		$Cargo_NPC.task_completed = true
		
	if $Cargo_NPC.cargo_count == numOfCargo:
		for point in enemy_spawning_point:
			point.active = false
			$Cargo_NPC.check_nearby_enemy()
	if $Cargo_NPC.cargo_count == numOfCargo and $Cargo_NPC.npc_is_safe:
		quest_completed = true
	
