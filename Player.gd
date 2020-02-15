extends Area2D
#defines custom signal
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hides the asset
	hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # Player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		#if moving, set velocity vector length to 1. Keeps diagnals from being faster than orthogonal
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	# delta is the amount of time the previous frame took to complete
	position += velocity * delta
	#moving boundaries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#flipping/swapping sprites
	if velocity.x != 0:
		#set animation cycle
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		#Boolean assignment is kinda like a reserve ternary. 
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		


		
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	#keeps collisions from stacking indefinitely. Set_deffered defers action until it's safe.
	$CollisionShape2D.set_deferred("disabled", true)
	
