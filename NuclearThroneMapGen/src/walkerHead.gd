extends Node2D

signal everyoneDone
const floorTiles := [0]
const wallTile := 1
#const floorTiles := [3,5,6]
#const wallTile := 4

var tilemap : TileMap 
var screensize : Vector2
var middleOfScreen : Vector2
export var spread := 5
export var startingUnitCount := 3

var doneWalkers := 0
var wallThreshold := 3

func _ready() -> void:
	randomize()
	tilemap = get_parent().get_node("TileMap")
	screensize = get_viewport_rect().size
	middleOfScreen = screensize / 2 
	spawnUnitsRandomly()
	connect("everyoneDone",self,"cleanMap")



func spawnUnitsRandomly() -> void:
	for i in startingUnitCount:
		universalSpawn(middleOfScreen)

func spawnUnitAtPoint(pos:Vector2) -> void:
	universalSpawn(pos)
	startingUnitCount += 1

func universalSpawn(pos) -> void:
	var walkerUnit :Node2D= preload("res://src/walkerUnit.tscn").instance()
	add_child(walkerUnit)
	walkerUnit.connect("tree_exiting", self, "collectFinishedWalkers")
	walkerUnit.global_position = pos

func collectFinishedWalkers() -> void: #	print("got a done one")
	doneWalkers += 1
	if doneWalkers == startingUnitCount: #		print("all walkers accounted for")
		emit_signal("everyoneDone")
	pass


func cleanMap() -> void:
	var rect :Rect2= tilemap.get_used_rect()
	placeBoxAround(rect) #	PLACE BOX AROUND
#	removeSingleSquares(rect) #	CLEAN UP


func placeBoxAround(rect:Rect2) -> void:
	var margin := 10
	for x in range( -margin, rect.size.x+margin ):
		for y in range ( -margin, rect.size.y+margin  ):
			var poses := Vector2(rect.position.x + x, rect.position.y + y )
			if not cellLocationPassedInIsFloor( tilemap.get_cell(poses.x, poses.y) ):
				tilemap.set_cell( poses.x, poses.y, wallTile )
				
func removeSingleSquares(rect:Rect2) -> void:
#	LOTS OF EXPERIMENTATION HERE, PLAY WITH 

	for x in rect.size.x:
		for y in rect.size.y:
			var poses := Vector2(rect.position.x + x, rect.position.y + y )
			var cellType :int= tilemap.get_cell(poses.x, poses.y)
			var count := 0 
			
			for xx in range (-1, 2):
				for yy in range (-1,2):
					if xx and yy == 0:
						continue
					else:
						var celltype :int= tilemap.get_cell(poses.x-xx, poses.y-yy)
						for floortype in floorTiles:
							if cellType == floortype:
								count += 1
	
			if count < 6:
				tilemap.set_cell(poses.x, poses.y, wallTile)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("r"):
		get_tree().reload_current_scene()

func getRandPrettyFloor() -> int:
	var r :int= floorTiles[ floor(randf()*floorTiles.size()) ]
	return r

func cellLocationPassedInIsFloor(cellType:int) -> bool:
	for floorType in floorTiles:
		if cellType == floorType:
			return true 
	return false
