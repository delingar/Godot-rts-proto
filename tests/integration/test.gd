extends GutTest

func test_testing():
	pass_test("Done.")

# Тест: Выделение и перемещение юнита
func test_unit_selection_and_movement():
	var unit = load("res://source/match/units/Unit.gd")
	var initial_position = Vector3(1,0,0)
	var target_position = initial_position + Vector3(10, 0, 0)

	# Переменная для отслеживания выделения
	var is_selected = false

	# Симулируем выделение
	unit.emit_signal("selected")
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	assert_true(is_selected, "Юнит должен быть выделен после сигнала 'selected'")
	assert_eq(unit.location, target_position, "Юнит должен переместиться в целевую позицию")

	# Симулируем снятие выделения
	unit.emit_signal("deselected")
	assert_false(is_selected, "Юнит должен быть снят с выделения после сигнала 'deselected'")
	
func test_group_selection():
	var unit1 = load("res://source/match/units/Worker.gd")
	var unit2 = load("res://source/match/units/Tank.gd")
	var selected_units = []

	unit1.connect("selected", func(): selected_units.append(unit1))
	unit2.connect("selected", func(): selected_units.append(unit2))

	# Симуляция группового выделения
	unit1.emit_signal("selected")
	unit2.emit_signal("selected")

	assert_eq(selected_units.size(), 2, "Должны быть выделены два юнита")
	assert_true(unit1 in selected_units, "Юнит 1 должен быть в списке выделенных")
	assert_true(unit2 in selected_units, "Юнит 2 должен быть в списке выделенных")

func test_auto_attack():
	var attacker = load("res://source/match/units/Tank.gd")
	var enemy = load("res://source/match/units/Worker.gd")
	var enemy_hp_before = enemy.hp
	
	# Запускаем автоатаку
	attacker.target_unit = enemy
	
	assert_lt(enemy.hp, enemy_hp_before, "После атаки HP врага должно уменьшиться")

func test_building_construction():
	# Симулируем команду на строительство
	var command_center = load("res://source/match/units/CommandCenter.gd")
	command_center.construct(10)
	# Ждём завершения строительства
	await get_tree().create_timer(command_center.build_time).timeout

	assert_true(command_center.constructed, "Здание должно быть построено после завершения строительства")
