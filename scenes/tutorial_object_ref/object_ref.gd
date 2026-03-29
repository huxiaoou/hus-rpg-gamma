extends Node

var a: Array[int] = []
var b: Array[int] = []

func _ready() -> void:
    for i:int in range(6):
        a.append(i)
    b = a.duplicate()
    print("a=", a)
    print("b=", b)
    a.clear()
    print("a=", a)
    print("b=", b)
