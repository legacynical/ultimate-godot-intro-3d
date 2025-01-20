extends Control

@export var player: CharacterBody3D
@export var player_speed: Label

func _process(_delta):
	player_speed.text = (
		"velocity X: " + str(snapped(player.velocity.x, 0.0001)) + "\n" +
		"velocity Z: " + str(snapped(player.velocity.z, 0.0001)) + "\n" +
		"velocity Y: " + str(snapped(player.velocity.y, 0.0001))
	)
