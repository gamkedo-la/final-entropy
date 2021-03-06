extends Spatial
class_name AIController
signal state_changed(new_state)
signal near_player

onready var steering: Spatial = $Steering
onready var aim_ray: RayCast = $AimRay
onready var weapon_mount: Spatial = $Weapons

var actor = null
var actor_velocity: Vector3 = Vector3.ZERO

var target: KinematicBody = null
var origin: Vector3 = Vector3.ZERO
var journey_distance: float = 0.0
var journey_percent: float = 0.0
var last_jp: float = 0.0
var last_jp_cnt: int = 0


var in_range: bool = false

enum State {
	IDLE,
	PATROL,
	ENGAGE,
	FIXEDAIM,
	SLEEP,
	DEAD
}

#Free fire will fire while moving
#FIXED fire will stop, anchor and fire a barrage
enum EngageMode {
	FREE,
	FIXED,
	NONPROJECTILE
}

export (EngageMode) var engage_style = EngageMode.FREE
export (bool) var start_on_own = false
var current_state: int = State.IDLE setget set_state

#State Timers
export (NodePath) var anim_tree
export (NodePath) var anim_play_node
var an_tree: AnimationTree
var state_machine
var anim_player: AnimationPlayer
# Time to wait before firing on a newly engaged target, to avoid instant fire
export (float) var engage_speed = 2.0
var engage_time: float = 0.0
# Time to continue firing on a target before resuming engage
export (float) var fire_time = 2.0
var firing_time: float = 0.0
# Time to wait to begin firing again
export (float) var cooldown_time = 4.0
var cooldown: float = 0.0
var cooling_down: bool = false
# Time to wait to return to patrolling/stop chasing a just lost target
export (float) var patrol_wait = 3.0
var patrol_time: float = 0.0
#Time to idle before returning to patrol
export (float) var idle_wait = 6.0
var idle_time: float = 0.0

var patrol_target: Vector3 = Vector3.ZERO
export (float, 1.0, 100.0) var patrol_range = 6.0
var patrol_reached: bool = true
onready var patrol_points_path: Spatial = $PatrolPoints
var patrol_points = []
var has_points: bool = false
var num_patrol_points: int = 20
var current_patrol_point: int = 0


# Time to wait to return to origin position after chasing a target to a new area
onready var origin_timer = Timer.new()
var origin_wait = 45

onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
#	set_state(State.IDLE)
	DebugOverlay.draw.add_point(self, "patrol_target", 10, Color.red)
	Music.register_enemy(self)
	if patrol_points_path.get_child_count() > 0:
		patrol_points_path.set_as_toplevel(true)
		patrol_points.append_array(patrol_points_path.get_children())
		has_points = true


func _physics_process(delta: float) -> void:
	if !actor:
		return
	
	match current_state:
		State.PATROL:
			_patrol()
		State.ENGAGE:
			_engage(delta)
		State.FIXEDAIM:
			_engage(delta)
		State.IDLE:
			_idle(delta)
		State.SLEEP:
			_sleep()
		State.DEAD:
			_dead()
		_:
			printerr("Error: Found a state for enemy that should not exist", self)

func initialize(newActor):
	actor = newActor
	origin = actor.transform.origin	
	print_debug("Getting to AI Initialize")
	steering.initialize(newActor, self)
	for weap in weapon_mount.get_children():
		weap.initialize(actor, steering, self)
	an_tree = get_node_or_null(anim_tree)
	anim_player = get_node_or_null(anim_play_node)
	if is_instance_valid(an_tree):
		state_machine = an_tree["parameters/playback"]
		print_debug(state_machine)
	else:
		print_debug("Failed to initialize AnimationTree")
	ani_travel("idle")
	if start_on_own:
		set_state(State.PATROL)
	else:
		set_state(State.IDLE)

func set_state(new_state: int) -> void:
	if new_state == current_state:
		return
	current_state = new_state
	emit_signal("state_changed", current_state)
	if current_state == State.ENGAGE && engage_style != EngageMode.NONPROJECTILE:
		ani_travel("move_bt_engage")
	if current_state == State.DEAD && in_range == true:
		emit_signal("near_player", false)
		in_range = false

func ani_travel(tree_node) -> void:
	if is_instance_valid(state_machine):
		state_machine.travel(tree_node)
#		print_debug("Changing State Machine")
#		match current_state:
#			State.PATROL:
#				state_machine.travel("move")
#			State.IDLE:
#				state_machine.travel("idle")
#			_:
#				printerr("Error: Found a state for enemy that should not exist", self)

func get_current_target() -> Vector3:
	if target:
		return to_local(target.global_transform.origin)
	elif patrol_target:
		return to_local(patrol_target)
	else:
		return Vector3.ZERO

func fixed_fire(delta: float, targ: Player) -> void:
	if current_state != State.FIXEDAIM:
		engage_time = 0.0
		set_state(State.FIXEDAIM)
		return
	engage_time += delta
	if engage_time > engage_speed:
		firing_time += delta
		if firing_time < fire_time:
			for weapon in weapon_mount.get_children():
				weapon.look_at(targ.global_transform.origin, Vector3.UP)
				if weapon.has_method("fire"):
					weapon.fire()
		else: 
			engage_time = 0.0
			firing_time = 0.0
			cooling_down = true
			set_state(State.ENGAGE)


func free_fire() -> void:
	pass
	
func body_attack() -> void:
	pass

func _patrol() -> void:
	if state_machine:
		an_tree.set("parameters/move_bt/TimeScale/scale", (steering.velocity.length() / actor.MAX_SPEED) * 2.0)
#		print_debug(state_machine.)
	if (patrol_target.distance_to(actor.global_transform.origin) < 1.5) || (last_jp_cnt == 60):
		patrol_reached = true
		last_jp = 0.0
		last_jp_cnt = 0

	if !patrol_reached:
		journey_percent = clamp(actor.global_transform.origin.distance_to(patrol_target) / journey_distance, 0.2, 1.0)
	else:
		if has_points:
			current_patrol_point += 1
			if current_patrol_point > patrol_points.size() - 1:
				current_patrol_point = 0 
			patrol_target = patrol_points[current_patrol_point].global_transform.origin
		else:
			var random_x = rng.randf_range(-patrol_range, patrol_range)
			var random_z = rng.randf_range(-patrol_range, patrol_range)
			patrol_target = Vector3(random_x, 0.0, random_z) + actor.global_transform.origin
		journey_distance = actor.global_transform.origin.distance_to(patrol_target)
		patrol_reached = false
	if abs(journey_percent - last_jp) < 0.001:
#		print_debug("journey_percent:", journey_percent, " last_jp: ", last_jp, " diff: ", journey_percent-last_jp)
		last_jp_cnt += 1
	else:
		last_jp = 0
	last_jp = journey_percent

func _engage(delta: float) -> void:
	if !cooling_down:
		if aim_ray.is_colliding():
			var p_check = aim_ray.get_collider().get_parent()
#			print_debug("p_check: ", p_check, "aim_ray.: ", aim_ray.get_collider().get_parent())
			if aim_ray.get_collider().get_parent() is Player:
				match engage_style:
					EngageMode.FIXED:
						fixed_fire(delta, p_check)
					EngageMode.FREE:
						free_fire()
					EngageMode.NONPROJECTILE:
						body_attack()
					_:
						printerr("Error: Found a engage mode for enemy that should not exist", self)
	else:
		cooldown += delta
		if cooldown > cooldown_time:
			cooldown = 0.0
			cooling_down = false
			


func _sleep() -> void:
	pass

func _dead() -> void:
	pass

func _idle(delta: float) -> void:
	idle_time += delta
	if idle_time > idle_wait:
		idle_time = 0.0
#		set_state(State.PATROL)
		ani_travel("move_bt")
	pass

func _test_func() -> void:
	print_debug("Yeah the animation played")


func _on_AggroBox_body_entered(body):
	if body.is_in_group("player"):
		target = body
#		Music.regist
		set_state(State.ENGAGE)
		if actor.is_a_boss:
			Music.boss_inrange = true
			if !actor.boss_triggered:
				Music.boss_from_the_top()
				actor.boss_triggered = true
	pass # Replace with function body.

