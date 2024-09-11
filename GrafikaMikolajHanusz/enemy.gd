extends CharacterBody3D

@onready var animated_sprite = $AnimatedSprite3D
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")

@export var move_speed = 2.0
@export var attack_range = 2.0

var dead = false
func _ready():
	animated_sprite.animation_finished.connect(animDone)

func _physics_process(delta):
	if dead or player == null :
		return
	var  dir = player.global_position - global_position
	dir.y = 0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	move_and_slide()
	attack()

func attack():
	var disToPlayer = global_position.distance_to(player.global_position)
	if disToPlayer > attack_range:
		return
	var eye = Vector3.UP * 1.5
	var q = PhysicsRayQueryParameters3D.create(global_position + eye, player.global_position+eye,1)
	var result = get_world_3d().direct_space_state.intersect_ray(q)
	if result.is_empty():
		player.kill()

func  kill():
	dead = true
	animated_sprite.play("death")
	$CollisionShape3D.disabled = true

func animDone():
	animated_sprite.visible = false
