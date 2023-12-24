extends CollisionShape2D

func _ready():
	self.disabled = true
	print("Collision Shape Disabled")
	await get_tree().create_timer(1).timeout
	print("Collision Shape Re-enabled")
	self.disabled = false
