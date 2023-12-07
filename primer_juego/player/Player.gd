extends Area2D

signal picked
signal hurt

func _ready():
	OS.center_window() # centrar la pantalla del juego al medio
	$AnimatedSprite.play("idle")


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position.x += -200 * delta
		$AnimatedSprite.flip_h = true # Voltear la figura
		
	if Input.is_action_pressed("ui_right"):
		position.x += 200 * delta
		$AnimatedSprite.flip_h = false
		
	if Input.is_action_pressed("ui_up"):
		position.y += -200 * delta
		
	if Input.is_action_pressed("ui_down"):
		position.y += 200 * delta

	process_animations()
	
	# Limitar el movimiento en el eje X y Y
	position.x = clamp(position.x, 0, 480)
	position.y = clamp(position.y, 0, 680)
	
func process_animations():
	if Input.is_action_pressed("ui_left") == true:
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_right") == true:
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_up") == true:
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_down") == true:
		$AnimatedSprite.play("run")
	else: 
		$AnimatedSprite.play("idle")

func _on_Player_area_entered(area):
	if area.is_in_group("Gem"):
		area.pickup()
		$AudioStreamPlayer2D.play()
		emit_signal("picked")
	
	
func game_over():
	set_process(false) # detener la función _process
	$AnimatedSprite.play("hurt")
	

func _on_Player_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("hurt")
