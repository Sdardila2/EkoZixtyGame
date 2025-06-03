extends VBoxContainer

@onready var level_display= $levelDsiplay
@onready var kills_display= $killsDsiplay2

var level: String = str(84)
var kills: String = str(1928)

func _process(delta):
	#level= str(global.level)
	#kills= str(global.current_kills)
	update_text()

func update_text():
	level_display.text=("LEVEL: " + level)
	kills_display.text=("KILLS: " + kills)
