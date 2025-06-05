@icon("res://npc/icon/npc.svg")
class_name NPC extends CharacterBody2D

signal do_behavior_enable

var state : String = "idle"
var direction: Vector2 = Vector2.DOWN
var direction_name : String = "down"


@export var npc_resources : NPCResource
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	
	pass

func setup_npc()-> void:
	if npc_resources:
		sprite.texture=npc_resources.sprite
	pass
