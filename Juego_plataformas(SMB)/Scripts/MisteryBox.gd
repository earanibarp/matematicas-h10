extends StaticBody2D

# Cargar la escena del coin
onready var coin = load("res://Scenes/coin.tscn")

export var hit_times = 1

func spawn_coins():
	var new_coin = coin.instance()
	add_child(new_coin)

func spawn_mushroom():
	pass

func _ready():
	$AnimationPlayer.play("default")
	

func _on_HitBox_body_entered(body):
	if body.is_in_group("player") && hit_times > 0:
			hit_times -= 1
			$AnimationPlayer.play("hitBox")
			

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hitBox" && hit_times > 0:
		$AnimationPlayer.play("default")
