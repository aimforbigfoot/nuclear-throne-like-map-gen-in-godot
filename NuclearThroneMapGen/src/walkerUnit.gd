extends Node2D

signal doneMoving

enum dirs {LEFT, RIGHT, UP, DOWN }
var lastDir := -1 
var givenBirth := false
var isStraightWalker := true
const tileSize := 16
export var pathLength := 100
export var birthChance := 0.05
export var dieChance := 0.01
export var chanceToWalkStraight := 0.01
export var amtToWalkStraightFor := 10

func _ready() -> void:
#	randomizeStats()
	calculatePath()
	queue_free()

func calculatePath() -> void:
	var pathSteps := []
	var prevDir := -1 
	for i in pathLength:
		
		var v := randi()%dirs.size()
		if prevDir != -1:
			if v == prevDir:
				if v < 3:
					v += 1
				else:
					v -= 1 # basically not same direciton
		prevDir = v
		pathSteps.append( v )
		
		if randf() < chanceToWalkStraight and isStraightWalker:
			for j in amtToWalkStraightFor:
				pathSteps.append(v)
		
		
	var pos = get_parent().middleOfScreen
	
	for dir in pathSteps:
		var subVal : Vector2
		match dir:
			0: #Left
				subVal += Vector2.LEFT
			1:
				subVal += Vector2.RIGHT
			2:
				subVal += Vector2.UP
			3:
				subVal += Vector2.DOWN
		
		subVal *= tileSize
		pos += subVal
		setTile(pos)
	
		if randf() < birthChance and not givenBirth:
			get_parent().spawnUnitAtPoint(pos)
			givenBirth = true
		
		if randf() < dieChance:
			emit_signal("doneMoving")
			return

	emit_signal("doneMoving")


func setTile(globalPos) -> void:
	var tm : TileMap = get_parent().tilemap
	var pos = tm.world_to_map( globalPos )
	tm.set_cell( pos.x, pos.y , get_parent().getRandPrettyFloor() )

func randomizeStats() -> void:
	randomize()
	pathLength = rand_range(50,200)
	birthChance = rand_range(0.001, 0.05)
	dieChance = rand_range(0,0.01)/2
	chanceToWalkStraight = rand_range(0.001, 0.02)
	amtToWalkStraightFor = rand_range(4,20)
