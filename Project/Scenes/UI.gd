extends CanvasLayer


var hp = 0
var _init_hp = 100

func change_player_hp(current_hp):
	hp = current_hp

func change_player_init_hp(current_hp):
	_init_hp = current_hp
	
func add_infos_about_quest(infos):
	$Quest_Info_Collection.info_container = infos
	$Quest_Info_Collection.clean_infos()
	$Quest_Info_Collection.add_infos()
