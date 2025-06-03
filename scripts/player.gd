extends CharacterBody2D

@export var inventory : Inventory

var enemy_inattack_range = false
var enemy_attack_cooldown = true

var player_alive = true

var SPEED = GlobalVariables.player_speed
var current_dir = "down"
var attacking = false

var attack_ip = false

var level = GlobalVariables.player_level
var experience = 0
var ex_limit = 100
var health = GlobalVariables.player_health
var max_health = health
var armor = GlobalVariables.player_armor
var damage = GlobalVariables.player_damage

signal changed_xp(value)
signal changed_xp_limit(value)
signal changed_hp(value)
signal changed_max_hp(value)
signal changed_armor(value)
signal changed_level(value)
signal changed_damage(value)

func _physics_process(delta: float) -> void:
	if attacking:
		return  # bloquea todo mientras ataca
	player_movement(delta)
	enemy_attack()
	attack()
	updateHealth()
	 
	if health <= 0:
		player_alive = false #add endscreen, etc.
		health = 0
		print("Player has been slained")
		self.queue_free()
		
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
	if Input.is_action_just_pressed("level_up"):
		dev_force_level_up()
	if Input.is_action_just_pressed("gain_xp") and level < 30:
		add_xp()

func start_attack():
	attacking = true
	var anim = $AnimatedSprite2D

	if current_dir == "right": 
		anim.play("attack_right")
		$DealAttackTimer.start()
	elif current_dir == "left":
		anim.play("attack_left")
		$DealAttackTimer.start()
	elif current_dir == "down":
		anim.play("attack_down")
		$DealAttackTimer.start()
	elif current_dir == "up":
		anim.play("attack_up")
		$DealAttackTimer.start()

	# Espera a que termine la animación
	await anim.animation_finished
	attacking = false


func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - (GlobalVariables.slime_damage*100)/(100+GlobalVariables.player_armor)
		emit_signal("changed_hp", round(int(health)))
		enemy_attack_cooldown = false
		$AttackCooldown.start()

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	var _dir = current_dir
	if Input.is_action_just_pressed("attack"):
		GlobalVariables.player_current_attack = true
		attack_ip = true
		
func _on_deal_attack_timer_timeout() -> void:
	$DealAttackTimer.stop()
	GlobalVariables.player_current_attack = false
	attack_ip = false


func updateHealth():
	$TextureProgressBar.max_value = max_health
	var healthbar = $TextureProgressBar
	healthbar.value = health
	
func _on_regen_time_timeout() -> void:
	if health < max_health:
		health+=1.8
		emit_signal("changed_hp", round(int(health)))
	if health > max_health:
		health = max_health
		emit_signal("changed_hp", round(int(health)))
			
	if health <= 0:
		health = 0
	
func _on_enemy_slime_died(value: Variant) -> void:
	experience += value
	changed_xpe()
		
func changed_xpe():
	if level < 30:
		if experience >= ex_limit:
			level += 1
			emit_signal("changed_level", level)

			ex_limit = 100 * pow(level, 1.5)
			emit_signal("changed_xp_limit", ex_limit)

			max_health = GlobalVariables.player_health + (level - 1) * 250
			emit_signal("changed_max_hp", max_health)

			armor += (level - 1) * 20
			emit_signal("changed_armor", armor)
			
			damage += 20
			emit_signal("changed_damage", damage)
			
			experience = 0
		emit_signal("changed_xp", experience)
	else:
		pass

func dev_force_level_up():
	if level < 30:
		experience = ex_limit
		changed_xpe()
		print("DEBUG: Nivel forzado a ", level)
	else:
		print("DEBUG: Nivel máximo alcanzado")

func add_xp():
	experience += 100
	changed_xpe()
	print(level)
	print(experience)
	
	
	
