extends CharacterBody2D

@export var speed := 60
var player: Node2D = null
var player_chase := false

func _ready():
	add_to_group("enemy")


func _physics_process(_delta: float) -> void:
	if player_chase and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle_down")

	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		if direction.y > 0:
			$AnimatedSprite2D.play("walk_down")
		else:
			$AnimatedSprite2D.play("walk_up")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
