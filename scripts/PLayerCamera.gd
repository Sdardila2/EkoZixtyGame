class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalLevelManager.TileMapBoundsChanged.connect(UpdateLimits)
	UpdateLimits(GlobalLevelManager.current_tilemap_bounds)
	match get_tree().current_scene.scene_file_path:
		"res://scenes/ForestMap.tscn":
			zoom = Vector2(3, 3)
		("res://scenes/CityMap.tscn"):
			zoom = Vector2(3, 3) 
		("res://scenes/BeachMap.tscn"):
			zoom = Vector2(3, 3) 
		("res://scenes/ToxicMap.tscn"):
			zoom = Vector2(3, 3) 
		("res://scenes/main.tscn"):
			zoom = Vector2(3, 3) 
	pass # Replace with function body.


func UpdateLimits( bounds : Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left= int(bounds[0].x)
	limit_top= int(bounds[0].y)
	limit_right= int(bounds[1].x)
	limit_bottom= int(bounds[1].y)
	pass
