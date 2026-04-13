extends PanelContainer


func _ready() -> void:
    visible = false


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_ui_mgr_legend"):
        visible = !visible
