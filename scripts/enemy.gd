extends CharacterBody2D

@export var speed = GlobalVariables.enemy_speed
var player: Node2D = null
var player_chase := false
var returning := false
var start_position: Vector2

var health = GlobalVariables.slime_health
var player_inattack_zone = false
var can_take_damage = true
var dying = false

func _ready():
	start_position = global_position  # Guarda la posición inicial

func _physics_process(_delta: float) -> void:
	if dying:
		return  # No hacer nada mientras muere

	deal_with_damage()
	updateHealth()

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
			if not dying:
				$AnimatedSprite2D.play("idle_down")
	else:
		velocity = Vector2.ZERO
		if not dying:
			$AnimatedSprite2D.play("idle_down")

	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if dying:
		return  # No actualizar animaciones si está muriendo

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
	if player_inattack_zone and GlobalVariables.player_current_attack and can_take_damage:
		health -= GlobalVariables.player_damage
		can_take_damage = false
		$TakeDamageCooldown.start()
		flash_red()
		if health <= 0:
			await die()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func die() -> void:
	dying = true
	print("Slime has been slained")
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func flash_red() -> void:
	var sprite = $AnimatedSprite2D
	var steps = 15
	var delay = 0.05  # 15 × 0.05 = 0.75s total
	var start_color = Color(1.0, 0.25, 0.0)  # rojo anaranjado intenso
	var end_color = Color(1, 1, 1)  # color normal (blanco)

	for i in range(steps + 1):
		var t = float(i) / steps
		sprite.self_modulate = start_color.lerp(end_color, t)
		await get_tree().create_timer(delay).timeout
		
func updateHealth():
	var healthbar = $TextureProgressBar
	healthbar.value = health
	
func _on_regen_time_timeout() -> void:
	if health < 5:
		health = health + 1
		if health > 5:
			health = 5
	if health <= 0:
		health = 0
