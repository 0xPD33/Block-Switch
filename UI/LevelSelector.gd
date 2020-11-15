extends Control

onready var level_button_grid = $TabContainer/MAIN/LevelSelectContainer/LevelButtonGrid


func _ready():
	level_button_grid.populate_grid()

