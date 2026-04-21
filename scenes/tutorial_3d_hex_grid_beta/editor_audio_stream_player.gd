extends AudioStreamPlayer

class_name EditorAudioStreamPlayer

@export_group("Audio Streams")
@export var btn_pressed: AudioStream
@export var hex_changed: AudioStream
@export var confirm: AudioStream
@export var cancel: AudioStream
@export var warning: AudioStream


func _play_sfx(sfx_stream: AudioStream) -> void:
    stream = sfx_stream
    play()


func play_btn_pressed() -> void:
    _play_sfx(btn_pressed)


func play_hex_changed() -> void:
    _play_sfx(hex_changed)


func play_confirm() -> void:
    _play_sfx(confirm)


func play_cancel() -> void:
    _play_sfx(cancel)


func play_warning() -> void:
    _play_sfx(warning)
