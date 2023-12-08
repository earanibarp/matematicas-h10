extends KinematicBody2D

export var speed = 150
export var gravity = 750
export var jump = -200

var velocity = Vector2.ZERO # (0,0)

enum {
	IDLE,
	RUN,
	JUMP,
	SLIDE
}

var state
var current_animation
var new_animation

enum PlayerMode{
	SMALL,
	BIG
}
var player_mode_priority = 0
var player_mode = PlayerMode.SMALL

const SMALL_MARIO_COLLISION = preload("res://collisions/small_player_collision.tres")
const SMALL_MARIO_HIT_COLLISION = preload("res://collisions/small_areaHit_collision.tres")
const BIG_MARIO_COLLISION = preload("res://collisions/big_player_collision.tres")
const BIG_MARIO_HIT_COLLISION = preload("res://collisions/big_areaHit_collision.tres")

func transition_to(new_state, play_mode):
	state = new_state
	match state:
		IDLE:
			new_animation = ("%s_idle" % PlayerMode.keys()[play_mode].to_lower())
		RUN:
			new_animation = ("%s_run" % PlayerMode.keys()[play_mode].to_lower())
		JUMP:
			new_animation = ("%s_jump" % PlayerMode.keys()[play_mode].to_lower())
		SLIDE:
			new_animation = ("%s_slide" % PlayerMode.keys()[play_mode].to_lower())

func _ready():
	transition_to(IDLE, player_mode_priority)

func _physics_process(delta):
	if current_animation != new_animation:
		current_animation = new_animation
		$AnimatedSprite.play(current_animation)
		
	# Agregar la gravedad
	velocity.y += gravity * delta
	
	velocity.x = 0
	
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
		transition_to(JUMP, player_mode_priority)
		
	if is_on_floor() and Input.is_action_just_pressed("ui_jump_big"):
		velocity.y = jump * 1.6
		transition_to(JUMP, player_mode_priority)
		
	velocity = move_and_slide(velocity, Vector2.UP) # UP -> (0,-1)
	
	if state == JUMP and is_on_floor():
		transition_to(IDLE, player_mode_priority)
	if state == IDLE and velocity.x != 0:
		transition_to(RUN, player_mode_priority)
	if state == RUN and velocity.x == 0:
		transition_to(IDLE, player_mode_priority)
	if state in [IDLE, RUN] and !is_on_floor():
		transition_to(JUMP, player_mode_priority)
	if state == RUN and Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		transition_to(SLIDE, player_mode_priority)
		yield(get_tree().create_timer(2), "timeout") #Crea un temporizador de 2sed
	if state == SLIDE and not (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left")):
		transition_to(RUN, player_mode_priority)


func _on_AreaHit_body_entered(body):
	if body.is_in_group("brick") && player_mode_priority == 0:
		body.bump()
		
	if body.is_in_group("brick") && player_mode_priority == 1:
		body.broken_brick()


func evolve(player_mode):
	var priority = null
	match player_mode:
		PlayerMode.SMALL:
			priority = 0
		PlayerMode.BIG:
			priority = 1
			$AnimatedSprite.play("small_to_big")
			
	if priority != player_mode_priority:
		player_mode_priority = priority
		
		
func change_shape_scale(is_small: bool):
	var collision_shape = SMALL_MARIO_COLLISION if is_small else BIG_MARIO_COLLISION
	var collision_shape_hit = SMALL_MARIO_HIT_COLLISION if is_small else BIG_MARIO_HIT_COLLISION
	$CollisionShape2D.set_deferred("shape", collision_shape)
	$AreaHit/CollisionShape2D.set_deferred("shape", collision_shape_hit)
	
func game_over():
	if player_mode_priority == 0:
		$AnimatedSprite.play("die")
		set_physics_process(false)
		
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self,"position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
	else:
		print("Big to Small")
		$AnimatedSprite.play("small_to_big")
		evolve(0)
		$CollisionShape2D.visible = false
		yield(get_tree().create_timer(1), "timeout")
		$CollisionShape2D.visible = true
		change_shape_scale(true)
