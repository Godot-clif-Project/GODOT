extends CanvasLayer


onready var player_state_info: Label = $MarginContainer/VBoxContainer/HBoxContainer/StateInfo
onready var player_healt_info: Label = $MarginContainer/VBoxContainer/HBoxContainer/HealthInfo
onready var player_stamina_progress: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/StaminaProgress



func _ready():
	player_stamina_progress.value = 100

func _on_Player_player_state(value):
	player_state_info.text = str(value)


func _on_StaminaDropTimer_timeout():
	player_stamina_progress.value -= 1


func _on_StaminaRaiseTimer_timeout():
	player_stamina_progress.value += 1
