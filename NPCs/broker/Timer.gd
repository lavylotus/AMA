extends Timer

#fix this for random breakdowns
func _process(delta):
	var breakTime = randi() % 1 + 10
	wait_time = breakTime
	start()
