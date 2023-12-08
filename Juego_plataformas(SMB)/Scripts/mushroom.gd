extends KinematicBody2D


const SPEED = 40
var velocity = Vector2(SPEED, 0)

func _ready():
	position = Vector2(8, -20)
	
func _physics_process(delta):
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity.y = 0
	else:
		#Aplicamos gravedad
		velocity.y += 1000 * delta
	
	# Cambiar de dirección cuando se encuentre contra la pared
	if is_on_wall():
		velocity.x = -velocity.x
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("player") && body.player_mode_priority == 0:
		print("Hongo recogido")
		body.evolve(1)
		body.change_shape_scale(false)
		queue_free()
