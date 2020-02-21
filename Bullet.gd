extends Area2D
export var speed = 800
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction
var velocity = Vector2() # Player's movement vector
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
#	pass
