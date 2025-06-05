extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/CityMap.tscn")


func _on_opciones_pressed():
	get_tree().change_scene_to_file("res://scenes/opciones.tscn")


func _on_salir_pressed():
	get_tree().quit()
