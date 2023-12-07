extends KinematicBody2D

export var speed = 150
export var gravity = 750
export var jump = -200

var velocity = Vector2.ZERO # (0,0)

enum {
	IDLE,
	RUN,
	JUMP,
	DIE,
	SLIDE
}

var state
var current_animation
var new_animation

func transition_to(new_state):
	state = new_state
	match state:
		IDLE:
			new_animation = "small_idle"
		RUN:
			new_animation = "small_run"
		JUMP:
			new_animation = "small_jump"
		DIE:
			new_animation = "die"
		SLIDE:
			new_animation = "small_slide"

func _ready():
	transition_to(IDLE)

func _physics_process(delta):
	if current_animation != new_animation:
		current_animation = new_animation
		$AnimatedSprite.play(current_animation)
		
	# Agregar la gravedad
	velocity.y += gravity * delta
	
	velocity.x = 0
	
#	#Si no se presiona ninguna tecla de movimiento: Desacelerar
#	if !Input.is_action_pressed("ui_left") or !Input.is_action_pressed("ui_right"):
#		velocity.x = lerp(velocity.x, 0.5, 1 * delta)
#		if abs(velocity.x) < 1.0:
#			velocity.x = 0
	
	# Movimiento del personaje
	if Input.is_action_pressed("ui_left"):
		velocity.x += -speed
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x += speed
		$AnimatedSprite.flip_h = false
	
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_acelerate"):
		velocity.x += -speed * 1.2
	elif Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_acelerate"):
		velocity.x += speed * 1.2

		
	if is_on_floor() and Input.is_action_pressed("ui_up"):
		velocity.y = jump
		transition_to(JUMP)
		
	if is_on_floor() and Input.is_action_just_pressed("ui_jump_big"):
		velocity.y = jump * 1.6
		transition_to(JUMP)
		
	velocity = move_and_slide(velocity, Vector2.UP) # UP -> (0,-1)
	
	if state == JUMP and is_on_floor():
		transition_to(IDLE)
	if state == IDLE and velocity.x != 0:
		transition_to(RUN)
	if state == RUN and velocity.x == 0:
		transition_to(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		transition_to(JUMP)
	if state == RUN and Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		transition_to(SLIDE)
		yield(get_tree().create_timer(2), "timeout") #Crea un temporizador de 2sed
	if state == SLIDE and not (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left")):
		transition_to(RUN)


func _on_AreaHit_body_entered(body):
	if body.is_in_group("brick"):
		body.bump()
