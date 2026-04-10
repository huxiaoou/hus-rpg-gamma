class_name DataMap
extends Resource

var data: Dictionary[Vector2i, DataMapCell] = { }


class DataMapCell extends RefCounted:
    var cell_loc: Vector2i
    var hex_tile: HexTile
