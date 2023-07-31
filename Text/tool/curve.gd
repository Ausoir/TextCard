class_name CurvedLine
extends Path2D


func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)


func _draw():
	var points = curve.get_baked_points()
	draw_polyline(points, Color.BLACK, 16, true)


func _process(_delta):
	queue_redraw()
