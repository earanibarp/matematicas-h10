extends Area2D

func pickup():
	queue_free()



func _on_gem_area_entered(area):
	if area.is_in_group("enemy"):
		self.position.x = rand_range(25,460)  # 0, 480
		self.position.y = rand_range(25, 700)  # 0, 720
