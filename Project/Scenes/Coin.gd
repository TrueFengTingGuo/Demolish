extends Area2D


func coin_collected():
	$AnimationPlayer.play("Coin_Bounce")
	set_collision_mask_bit(1,false)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Coin_body_entered(body):
	if body.is_in_group("Racer"):
		body.coins += 1
		coin_collected()
