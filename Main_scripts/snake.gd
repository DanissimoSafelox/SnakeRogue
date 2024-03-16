extends CharacterBody2D


@export var MAX_SPEED = 260
@export var ACCELERATION = 70
@export var start_segments = 3


var direction = Vector2.ZERO
var segment_chain = []

var segment = preload("res://Main_Scenes/segment.tscn")


func _ready():
	segment_spawn(start_segments)
	

func _physics_process(delta):
	head_moving()
	segment_moving()
	move_and_slide()
	
	
	
									#Пересортировка инвентаря - смещение к хвосту
func resort_inventory():
	var move_here_point = -1
	for i in segment_chain.size():
		if segment_chain[segment_chain.size() - i - 1].current_item == "empty":
			if move_here_point == -1:
				move_here_point = segment_chain.size() - i - 1
				print("move_here_point задана как ", move_here_point)
		elif move_here_point != -1:# если это первый предмет или идёт непрерывная цепочка предметов, то идём дальше, иначе сдвигаем предмет на точку перемещения
			segment_chain[move_here_point].change_current_item(segment_chain[segment_chain.size() - i - 1].current_item)
			segment_chain[segment_chain.size() - i - 1].change_current_item("empty")
			print("Сегмент, находящийся на ", segment_chain.size() - i - 1, " перемещен на ", move_here_point, ". Начинаю рекурсию!")
			resort_inventory()
			return

	
	print("Цепочка окончена")
	
	# НЕ ПРАВИЛЬНО
	'''
	var move_here_point: int # точка, куда двигаем крайне левый предмет
	var start_items = true #Маркер наличия предметов
				#ПОДУМАЦ
	while move_here_point < segment_chain.size() and start_items: # Пока точка не нашлась (нет свободных мест) (если не найдены предметы, то выходим)
		start_items = false
		move_here_point = segment_chain.size()
		print(segment_chain.size())
		#print(start_items)
		for i in segment_chain.size():
			if segment_chain[i].current_item == "empty": # проверяем на пустоту
				print("Пусто")
				if move_here_point > i:
					move_here_point = i
			else:
				print("предмет есть")
				start_items = true # Опа, нашелся предмет
				if move_here_point < segment_chain.size() : #Если это очередной сегмент с предметом, ставим на это место 
					segment_chain[move_here_point].change_current_item(segment_chain[i].current_item)
					segment_chain[i].change_current_item("empty")
					move_here_point += 1
					break # выходим из цикла for
			print("for")
		print("конец цикла while")
	'''
	
									#Подбор предмета и сортировка его в инвентарь
func take_item(new_item: Item):
	for i in segment_chain.size():
		var current_segment_number = segment_chain.size() - i - 1
		if segment_chain[current_segment_number].current_item == "empty":
			segment_chain[current_segment_number].change_current_item(new_item.Item_type)
			new_item.get_parent().queue_free()
			return
	
	
	
								#Создание сегментов
func segment_spawn(count):	 
	for i in count:
		var new_segment = segment.instantiate() # в переменной содержится экземпляр
		if segment_chain.size() == 0:
			new_segment.position = global_position
		else:
			new_segment.position = segment_chain[segment_chain.size() - 1].position
		segment_chain.push_back(new_segment)
		new_segment.head = self
		owner.add_child.call_deferred(new_segment) 
	
	
							#Движение сегментов
func segment_moving():	
	var head_pos
	var max_distance = 35 -15
	for i in segment_chain.size():
		if i == 0:
			head_pos = global_position
		var distance = head_pos - segment_chain[i].position
		if abs(distance.x) > max_distance or abs(distance.y) > max_distance:
			segment_chain[i].velocity = (head_pos - segment_chain[i].position).normalized() * MAX_SPEED
		
		else:
			segment_chain[i].velocity = Vector2.ZERO
		segment_chain[i].look =  distance.normalized().angle()
		head_pos = segment_chain[i].position
	
	
							#Движение головы
func head_moving():
					# Если кликаем - ищем расстояние и преобразуем длину в векторное направление
	if Input.is_action_pressed("click"):
		direction = (get_global_mouse_position() - global_position).normalized() 

				# Поворачиваем в сторону направления
	$Sprite2D.rotation = direction.angle()
	
				# Интересное движение с отклонениями в стороны
	'''
	velocity.x += direction.x * ACCELERATION
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED) 
	velocity.y += direction.y * ACCELERATION
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED) 
	'''
	
	velocity.x = direction.x * MAX_SPEED
	velocity.y = direction.y * MAX_SPEED 
	
	#Ещё вариант
	#velocity.x = clamp(direction.x, -1, 1)
	#velocity.y = clamp(direction.y, -1, 1)
	#velocity.x = move_toward(velocity.x, direction.x, SPEED)
	#velocity.y = move_toward(velocity.y, direction.y, SPEED)

