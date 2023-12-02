extends TextureRect

class_name Screen

const palette = [
	Color("#000000"), Color("#ffffff"), Color("#880000"), Color("#aaffee"),
	Color("#cc44cc"), Color("#00cc55"), Color("#0000aa"), Color("#eeee77"),
	Color("#dd8855"), Color("#664400"), Color("#ff7777"), Color("#333333"),
	Color("#777777"), Color("#aaff66"), Color("#0088ff"), Color("#bbbbbb")
]

# 32x32, or 1024
const num_pixels = 0x400
var img := Image.create(32, 32, true, Image.FORMAT_RGB8)
var max_queue_timer := 1.0 / 600.0
var queue_timer := 0.0

func _ready():
	img.fill(palette[0])
	set_texture(ImageTexture.create_from_image(img))

func set_pixel_col(index:int, color:int):
	var x := index % 32
	var y := floori(index / 32.0)
	img.set_pixel(x, y, palette[color & 0xf])

func _draw():
	texture.update(img)

func _process(delta):
	queue_redraw()

func clear():
	img.fill(palette[0])
