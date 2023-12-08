extends StaticBody2D

# Cargar la escena del coin
onready var coin = load("res://Scenes/coin.tscn")
onready var mushroom = load("res://Scenes/mushroom.tscn")

export var hit_times = 1

enum BonusType{
	COIN, #0 = Coin
	MUSHROOM #1 = Mushroom
}

export var bonus_type = BonusType.COIN

func spawn_coins():
	var new_coin = coin.instance()
	add_child(new_coin)
	get_parent().get_parent().points += 100

func spawn_mushroom():
	var new_mushroom = mushroom.instance()
	call_deferred("add_child", new_mushroom)

func _ready():
	$AnimationPlayer.play("default")
	

func _on_HitBox_body_entered(body):
	if body.is_in_group("player") && hit_times > 0:
		match bonus_type:
			BonusType.COIN:
				spawn_coins()
			BonusType.MUSHROOM:
				spawn_mushroom()
		hit_times -= 1
		$AnimationPlayer.play("hitBox")
		
			

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hitBox" && hit_times > 0:
		$AnimationPlayer.play("default")
