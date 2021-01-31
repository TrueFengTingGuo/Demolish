extends Area2D

export var collisionShapeSize = Vector2(10,10)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	if has_node("HeightBound") and has_node("WidthBound"):
		var heightBound = to_local(get_node("HeightBound").global_position)
		var widthBound = to_local(get_node("WidthBound").global_position)

		var region_width =abs(widthBound.x)
		var region_height = abs(heightBound.y)
		collisionShapeSize = Vector2(region_width,region_height/2)
		
		$Area.region_rect  = Rect2(0, 0, region_width*2, region_height*2)	
		$CollisionShape2D.shape.extents = collisionShapeSize

	else:
		$CollisionShape2D.shape.extents = collisionShapeSize
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

