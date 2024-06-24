extends CharacterBody2D

const SPEED = 120.0
const MOVE_ACCEL = 15.0
const MOVE_DECEL = 20.0
const JUMP_VELOCITY = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping = false

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false

	# Handle jump.
	if Input.is_action_just_released("jump") and velocity.y < -JUMP_VELOCITY / 4:
			velocity.y = -JUMP_VELOCITY / 4
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		is_jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Move sprite
	if direction:
		velocity.x += direction * MOVE_ACCEL
	else:
		if velocity.x > -MOVE_DECEL and velocity.x < MOVE_DECEL:
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= MOVE_DECEL
		elif velocity.x < 0:
			velocity.x += MOVE_DECEL
	
	velocity.x = clamp(velocity.x, -SPEED, SPEED)
	
	# Play animations
	if is_jumping:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	elif direction == 0:
		animated_sprite.play("default")
	else:
		animated_sprite.play("run")

	move_and_slide()
