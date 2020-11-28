extends Node


func custom_sort(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a < b

