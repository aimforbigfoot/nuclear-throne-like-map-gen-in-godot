extends Node2D

var tilemap : TileMap
var pathLength := 100
enum dirs {LEFT, RIGHT, UP, DOWN }
const tileSize := 16


func _ready() -> void:
	randomize()
#	calculate_path()
	pass


func calculate_path() -> void:
	var pathSteps := []
	for i in pathLength:
		var step := randi() % dirs.size()
		pathSteps.append( step )
	
	var location : Vector2 = get_parent().global_position
	var tm : TileMap = get_parent().tilemap
	
	for dir in pathSteps:
		var modifierDirection : Vector2
		match dir:
			0:
				modifierDirection = Vector2.LEFT
			1:
				modifierDirection = Vector2.RIGHT
			2:
				modifierDirection = Vector2.UP
			3:
				modifierDirection = Vector2.DOWN
		
		location += modifierDirection * tileSize
		var mapCords := tm.world_to_map(location)
		tm.set_cell(mapCords.x, mapCords.y, 1)




