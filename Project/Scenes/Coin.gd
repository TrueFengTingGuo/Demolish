extends Area2D

signal coin_collected

func _ready():
	
	connect("coin_collected",get_node("/root/Game"),"_on_coin_collected")

func _on_Coin_body_entered(body):
	$AnimationPlayer.play("Coin_Bounce")
	emit_signal("coin_collected")
	set_collision_mask_bit(1,false)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
