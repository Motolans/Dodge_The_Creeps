extends Area2D
#defines custom signal
signal hit
signal shoot



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 400
var screen_size

#for mouse click controls
var target = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hides the asset
	hide()
	
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
		print("CLICK")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var velocity = Vector2() # Player's movement vector
	if position.distance_to(target) > 10:
		velocity = (target - position).normalized() * speed
		
	else:
		velocity = Vector2()
	


#	if Input.is_action_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_left"):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1
	
		
	if Input.is_action_pressed("ui_up_shoot") or Input.is_action_pressed("ui_down_shoot") or Input.is_action_pressed("ui_left_shoot") or Input.is_action_pressed("ui_right_shoot"):
			#bullet = Bullet.instance()
			#add_child(bullet)
			create_bullet()
				
			
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
	#for mouse controls
	target = pos
	show()
	$CollisionShape2D.disabled = false

#built-in event function	




func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	#keeps collisions from stacking indefinitely. Set_deffered defers action until it's safe.
	$CollisionShape2D.set_deferred("disabled", true)
	
func create_bullet():
	emit_signal("shoot")