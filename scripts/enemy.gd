extends CharacterBody2D

@export var speed := 60
var player: Node2D = null
var player_chase := false
var returning := false
var start_position: Vector2

var health = Global.slime_health
var player_inattack_zone = false
var can_take_damage = true
func _ready():
	start_position = global_position  # Guarda la posición inicial del slime

func _physics_process(_delta: float) -> void:
	deal_with_damage()
	if player_chase and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		update_animation(direction)
	elif returning:
		var to_start = start_position - global_position
		if to_start.length() > 2:
			var direction = to_start.normalized()
			velocity = direction * speed
			update_animation(direction)
		else:
			velocity = Vector2.ZERO
			returning = false
			$AnimatedSprite2D.play("idle_down")
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
		returning = false

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
		returning = true

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			health = health - Global.player_damage
			$TakeDamageCooldown.start()
			can_take_damage = false
			print("Slime health = ", health)
			if health <= 0:
				print("Slime has been slained")
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
