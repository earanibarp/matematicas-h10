extends KinematicBody2D

export (int) var gravity 
export (int) var jump
export (int) var speed  

var velocity = Vector2.ZERO #Vector2(0,0)

enum {IDLE, CROAK, JUMP, FALL}

var state # guarda la animación: IDLE/CROAK/JUMP/FALL
var current_animation # animación actual
var new_animation # nueva animación en caso de que cambie

func transition_to(new_state):
	state = new_state
	match (state):
		IDLE:
			new_animation = "idle"
		CROAK:
			new_animation = "croak"
		JUMP:
			new_animation = "jump"
		FALL:
			new_animation = "fall"

func _ready():
	set_timer_interval_croak()
	set_timer_interval_jump()
	transition_to(IDLE)
	

func set_timer_interval_croak():
	#tiempo de animación de croak
	$Timer.wait_time = rand_range(4,6)
	$Timer.start()
	
func set_timer_interval_jump():
	#tiempo de animación de jump
	$JumpTimer.wait_time = rand_range(2,4)
	$JumpTimer.start()

func _on_Timer_timeout():
	$Timer.stop()
#	$AnimationPlayer.play("croak")
	if state == IDLE:
		transition_to(CROAK)
	set_timer_interval_croak()
	

func _physics_process(delta):
	velocity.y += gravity * delta 
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if new_animation != current_animation:
		current_animation = new_animation
		$AnimationPlayer.play(current_animation)
	if not is_on_floor() and velocity.y > 0:
		transition_to(FALL)
	if is_on_floor() and state == FALL:
		transition_to(IDLE)
		
	# Para dar movimiento
	if not is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0
	
	# Para voltear la figura	
	if speed > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "croak":
		transition_to(IDLE)


func _on_JumpTimer_timeout():
	$JumpTimer.stop()
	if state == IDLE:
		velocity.y = jump
		transition_to(JUMP)
		update_speed_direction()
	set_timer_interval_jump()

func update_speed_direction():
	var pulso = bool(randi()%2) # bool true (0) / bool false (1)
	if pulso == true:
		speed = speed * 1
	else:
		speed = speed * -1
	
