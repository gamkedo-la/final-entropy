extends Spatial


var actor: Actor = null
var ai: AIController = null
var actor_velocity: Vector3 = Vector3.ZERO
var actor_team: String
var origin: Vector3 = Vector3.ZERO

# Movement constants
const m_s_up = Vector3.ZERO
const m_s_sos = false
const m_s_maxsli = 4
const m_s_fma = 0.785398

var velocity: Vector3 = Vector3.ZERO

# Context-Base Steering Variables borrowing and adapting from concepts found @
# https://kidscancode.org/godot_recipes/ai/context_map/
export var steer_force = 0.1
export var look_ahead = 10
export var num_rays = 16

# context arrays
var ray_directions = []
var interest = []
var danger = []
var danger_pos = []

var chosen_dir: Vector3 = Vector3.ZERO
var acceleration: Vector3 = Vector3.ZERO
var steer_time: float = 1.0
var initialized: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# context steering prep
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector3.RIGHT.rotated(Vector3.UP, angle)
	
	DebugOverlay.draw.add_vector(self, "velocity", 1, 4, Color(0,1,0,0.5))
	DebugOverlay.draw.add_rayarray(self, ray_directions,look_ahead,1,Color.purple)	
	DebugOverlay.draw.add_hitarray(self, "danger_pos", 5, Color.aqua)
		
func _physics_process(delta: float) -> void:
	if !initialized:
		return
	if ai.current_state != ai.State.SLEEP:
		move(delta)

func move(delta: float) -> void:

	set_interest()
	set_danger()
	choose_direction()
	
	var desired_velocity = chosen_dir.rotated(Vector3.UP, actor.rotation.y) * (actor.MAX_SPEED)
	velocity = lerp(velocity, desired_velocity, steer_force * delta)
#	actor.rotation = velocity.

	velocity = actor.move_and_slide(velocity, m_s_up, m_s_sos, m_s_maxsli, m_s_fma, false)

func initialize(newActor: Actor, newAI: AIController):

	actor = newActor
	ai = newAI
	origin = actor.global_transform.origin
	initialized = true

func set_interest() -> void:
	var path_direction: Vector3 = ai.get_current_target()
	for i in num_rays:
		var d = ray_directions[i].dot(path_direction)
		interest[i] = max(1, d)

func set_danger() -> void:
	# Cast rays to find danger directions
	danger_pos = []
	var space_state = get_world().direct_space_state
	var actor_ori: Vector3 = actor.global_transform.origin
	for i in num_rays:
		var result = space_state.intersect_ray(actor_ori,
				actor_ori + ray_directions[i].rotated(Vector3.UP, actor.rotation.y) * look_ahead,
				[self,actor])
		
		if result:
#			print_debug("Ray result: ", result)
			danger[i] = actor_ori.distance_to(result.position) / look_ahead
			danger_pos.append(result.position)
		else:
			danger[i] = 0.0
#	DebugOverlay.draw.add_hitarray(self, danger_pos, 5, Color.aqua)

func choose_direction() -> void:
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] *= clamp(danger[i], 0.0, 1.0)
	
	chosen_dir = Vector3.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()
