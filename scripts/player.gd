extends CharacterBody2D

const SPEED = 150
var current_dir = "down"
var attacking = false

func _physics_process(delta: float) -> void:
	if attacking:
		return  # bloquea todo mientras ataca
	player_movement(delta)

func player_movement(_delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * SPEED
		update_direction()
		play_animation(1)
	else:
		play_animation(0)

	move_and_slide()

func update_direction():
	if abs(velocity.x) > abs(velocity.y):
		current_dir = "right" if velocity.x > 0 else "left"
	else:
		current_dir = "down" if velocity.y > 0 else "up"

func play_animation(movement):
	var anim = $AnimatedSprite2D
	match current_dir:
		"right":
			anim.play("run_right" if movement else "idle_right")
		"left":
			anim.play("run_left" if movement else "idle_left")
		"down":
			anim.play("run_down" if movement else "idle_down")
		"up":
			anim.play("run_up" if movement else "idle_up")

func _process(_delta):
	# Entrada de ataque
	if Input.is_action_just_pressed("attack") and not attacking:
		start_attack()

func start_attack():
	attacking = true
	var anim = $AnimatedSprite2D

	match current_dir:
		"right": anim.play("attack_right")
		"left": anim.play("attack_left")
		"down": anim.play("attack_down")
		"up": anim.play("attack_up")

	# Espera a que termine la animación
	await anim.animation_finished
	attacking = false
