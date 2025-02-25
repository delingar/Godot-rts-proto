extends GutTest

signal selected
signal deselected
# Подготовка тестовой среды
func before_all():
	var _movement = load("res://source/match/units/traits/Movement.gd")
	print("Запуск before_all()")

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

	# Симулируем перемещение юнита
	unit.find_child("Movement")
	
	# Обработчики сигналов
	unit.connect("selected", func(): is_selected = true)
	unit.connect("deselected", func(): is_selected = false)
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	assert_eq(unit.global_transform.origin, target_position, "Юнит должен переместиться в целевую позицию")

	# Симулируем снятие выделения
	unit.emit_signal("deselected")
	#await get_tree().process_frame
	#await get_tree().create_timer(1.0).timeout
	assert_false(is_selected, "Юнит должен быть снят с выделения после сигнала 'deselected'")
	
	print("Тест начался")
	pass_test(100)  # Завершаем тест принудительно
	print("Тест завершён")
