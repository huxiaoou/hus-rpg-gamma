extends Node

class_name NodeParent

func _ready() -> void:
    print("NodeParent is ready")
    for child_node: State in get_children():
        if child_node is State:
            print("Node is %s" % child_node.get_state_name())
