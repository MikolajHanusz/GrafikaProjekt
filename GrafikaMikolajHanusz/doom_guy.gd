extends CharacterBody3D
@onready var ray_cast = $RayCast3D
@onready var animated_sprite = $CanvasLayer/GunBase/AnimatedSprite2D
const SPEED = 5.0
const Mouse_SENS = 0.1
var canShoot = true
var dead=false

func _ready():
	$CanvasLayer/DeathScreen.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animated_sprite.animation_finished.connect(shootAnimDone)
	$CanvasLayer/DeathScreen/Panel/Button.button_up.connect(restart)

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * Mouse_SENS

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if dead:
		return
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if dead:
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func restart():
	get_tree().reload_current_scene()

func shoot():
	if !canShoot:
		return
	canShoot = false
	animated_sprite.play("shoot")
	if ray_cast.is_colliding() and ray_cast.get_collider().has_method("kill"):
		ray_cast.get_collider().kill()

func shootAnimDone():
	canShoot = true

func kill():
	dead = true
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
