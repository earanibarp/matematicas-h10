extends StaticBody2D

func bump():
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self, "position", position + Vector2(0,-5), .12)
	bump_tween.chain().tween_property(self, "position", position, .12)

func broken_brick():
	$Particles2D.emitting = true
	if $Particles2D.emitting:
		yield(get_tree().create_timer(0.5), "timeout")
		get_parent().remove_child(self)
