extends Control

@onready var inv : Inventory = preload("res://inventory/PlayerInventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

var is_open = false
var xp_limit = 100
var max_health = 2000
var level = 1
var armor = 0

func _ready():
	$NinePatchRect/PlayerHealth.text = "HP:"+str(GlobalVariables.player_health)+"/"+str(max_health)
	$NinePatchRect/PlayerArmor.text = "ARMOR:"+str(GlobalVariables.player_armor)
	$NinePatchRect/PlayerLevel.text = "LEVEL:"+str(GlobalVariables.player_level)
	$NinePatchRect/PlayerXp.text = "XP:"+str(GlobalVariables.player_xp)+"/"+str(xp_limit)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

func _on_player_changed_xp(value: Variant) -> void:
	if level < 30:
		$NinePatchRect/PlayerXp.text = "XP:"+str(value)+"/"+str(round(int(xp_limit)))
	else:
		$NinePatchRect/PlayerXp.text = "MAX LEVEL"
		
func _on_player_changed_hp(value: Variant) -> void:
	$NinePatchRect/PlayerHealth.text = "HP:"+str(value)+"/"+str(max_health)

func _on_player_changed_level(value: Variant) -> void:
	level+=1
	$NinePatchRect/PlayerLevel.text = "LEVEL:"+str(value)
	
func _on_player_changed_armor(value: Variant) -> void:
	armor+=1
	$NinePatchRect/PlayerArmor.text = "ARMOR:"+str(value)

func _on_player_changed_xp_limit(value: Variant) -> void:
	xp_limit = value

func _on_player_changed_max_hp(value: Variant) -> void:
	max_health = value
