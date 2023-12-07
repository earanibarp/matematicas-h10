extends Control



func _on_ButtonStart_pressed():
	get_tree().change_scene("res://main/Main.tscn")


func _on_ButtonExit_pressed():
	get_tree().quit()
