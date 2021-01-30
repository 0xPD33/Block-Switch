extends Sprite

# TODO: FIX THIS!
# Problem is that the value is way too big. region_rect size ends up at over 9 million

func multiply_region_rect(value):
	region_rect.size = region_rect.size * value

