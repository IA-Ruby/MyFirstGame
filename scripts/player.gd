extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var landing = false
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Press jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		if animated_sprite.animation != "JumpStart":
			animated_sprite.play("JumpStart")
	
	# Release jump
	if Input.is_action_just_released("jump") and is_on_floor():
		animated_sprite.play("Jump")
		velocity.y = JUMP_VELOCITY
		landing = true
	elif is_on_floor() and landing == true:
		animated_sprite.play("HitGround")
		landing = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
		
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Movement
	if direction and animated_sprite.animation != "JumpStart":
		velocity.x = direction * SPEED
		if landing == false and animated_sprite.animation != "HitGround": 
			animated_sprite.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "HitGround":
		animated_sprite.play("Iddle")
	if animated_sprite.animation == "walk":
		animated_sprite.play("Iddle")
