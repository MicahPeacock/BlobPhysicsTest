extends Node2D

const POINTS = 25
const RADIUS = 100.0
const OUTER_LAYER_OFFSET = 20.0
const CENTER_CONSTANT = 10.0
const INNER_RING_CONSTANT = 5.0
const OUTER_RING_CONSTANT = 5.0
const INNER_TO_OUTER_CONSTANT = 30.0
const INNER_TO_OUTER_DIAG_CONSTANT = 25.0 

var innerPointArray = []
var outerPointArray = []
var centerpoint

func _ready():
	var PointScene = load('res://Point.tscn')
	centerpoint = PointScene.instance()
	add_child(centerpoint)
	centerpoint.global_position = Vector2(200, 200)
	
	for i in range(POINTS):
		innerPointArray.push_back(PointScene.instance())
		add_child(innerPointArray[i])
		innerPointArray[i].position = RADIUS * Vector2(cos((i * 2 * PI) / POINTS), sin((i * 2 * PI) / POINTS)) + centerpoint.global_position
		innerPointArray[i].list1.push_back(centerpoint)
		innerPointArray[i].list2.push_back(RADIUS)
		innerPointArray[i].list3.push_back(CENTER_CONSTANT)
		centerpoint.list1.push_back(innerPointArray[i])
		centerpoint.list2.push_back(RADIUS)
		centerpoint.list3.push_back(CENTER_CONSTANT)
		
		outerPointArray.push_back(PointScene.instance())
		add_child(outerPointArray[i])
		outerPointArray[i].position = (RADIUS + OUTER_LAYER_OFFSET) * Vector2(cos((i * 2 * PI) / POINTS), sin((i * 2 * PI) / POINTS)) + centerpoint.global_position
		outerPointArray[i].list1.push_back(innerPointArray[i])
		outerPointArray[i].list2.push_back(OUTER_LAYER_OFFSET)
		outerPointArray[i].list3.push_back(INNER_TO_OUTER_CONSTANT)
		
		innerPointArray[i].list1.push_back(outerPointArray[i])
		innerPointArray[i].list2.push_back(OUTER_LAYER_OFFSET)
		innerPointArray[i].list3.push_back(INNER_TO_OUTER_CONSTANT)
	
	var distance_in = (RADIUS * PI * 2) / POINTS
	var distance_out = ((RADIUS + OUTER_LAYER_OFFSET) * PI * 2) / POINTS
	var distance_diag = innerPointArray[0].global_position.distance_to(outerPointArray[1].global_position)
	
	for i in range(POINTS):
		var index = i - 1
		if i == 0:
			index = POINTS - 1
		innerPointArray[i].list1.push_back(innerPointArray[index])
		innerPointArray[i].list2.push_back(distance_in)
		innerPointArray[i].list3.push_back(INNER_RING_CONSTANT)
		innerPointArray[index].list1.push_back(innerPointArray[i])
		innerPointArray[index].list2.push_back(distance_in)
		innerPointArray[index].list3.push_back(INNER_RING_CONSTANT)
		
		outerPointArray[i].list1.push_back(outerPointArray[index])
		outerPointArray[i].list2.push_back(distance_out)
		outerPointArray[i].list3.push_back(OUTER_RING_CONSTANT)
		outerPointArray[index].list1.push_back(outerPointArray[i])
		outerPointArray[index].list2.push_back(distance_out)
		outerPointArray[index].list3.push_back(OUTER_RING_CONSTANT)
		
		innerPointArray[i].list1.push_back(outerPointArray[index])
		innerPointArray[i].list2.push_back(distance_diag)
		innerPointArray[i].list3.push_back(OUTER_RING_CONSTANT)
		outerPointArray[index].list1.push_back(innerPointArray[i])
		outerPointArray[index].list2.push_back(distance_diag)
		outerPointArray[index].list3.push_back(OUTER_RING_CONSTANT)

#func _physics_process(delta):
#	centerpoint.global_position = get_global_mouse_position()
