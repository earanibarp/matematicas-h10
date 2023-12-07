extends Control


func update_score(val):
	$MarginContainer/LabelScore.text = str(val)
	
func update_timer(val):
	$MarginContainer/LabelTimer.text = str(val)
