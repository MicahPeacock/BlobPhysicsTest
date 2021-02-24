extends KinematicBody2D

#const SPRING = 20
const GRAVITY = Vector2(0.0, 100.0)

var list1 = []
var list2 = []
var list3 = []
var movement

func _ready():
	movement = Vector2(0.0,0.0)

func _process(delta):
	movement = move_and_slide(movement + calculate_total_force())
	
func calculate_total_force():
	var force = GRAVITY
	for i in range(list1.size()):
		force += (global_position.distance_to(list1[i].global_position) - list2[i])	 * list3[i] * global_position.direction_to(list1[i].global_position)
	return force
