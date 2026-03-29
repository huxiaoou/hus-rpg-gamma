extends Area2D

class_name Area2DMonitor

func _ready() -> void:
    monitorable = false
    monitoring = false
    
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        if monitorable:
            print("Area2D is monitorable")
        else:
            print("Area2D is not monitorable")
        if monitoring:
            print("Area2D is monitoring")
        else:
            print("Area2D is not monitoring")
