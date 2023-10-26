extends Area2D

func _ready():
	OS.center_window() # centrar la pantalla del juego al medio
#	position = Vector2(100, 100)


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
	
	# Limitar el movimiento en el eje X y Y
	position.x = clamp(position.x, 0, 480)
	position.y = clamp(position.y, 0, 680)
	


func _on_Player_area_entered(area):
	if area.is_in_group("Gem"):
		print("Gema encontrada!")
		area.pickup()
	
	
	
	
	
	
	
	
