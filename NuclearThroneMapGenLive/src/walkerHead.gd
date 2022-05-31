extends Node2D

var tilemap : TileMap
# Generate Black Box Around Map 

func _ready() -> void:
	randomize()
	tilemap = get_parent().get_node("TileMap")
	for child in get_children():
		if child.has_method("calculate_path"):
			child.calculate_path()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("r"):
		get_tree().reload_current_scene()
