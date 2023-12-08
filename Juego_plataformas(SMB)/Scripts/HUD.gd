extends CanvasLayer

func _process(delta):
	$LabelPoints.text = str(get_parent().points)
