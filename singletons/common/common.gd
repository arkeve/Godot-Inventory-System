extends Node

var _isDebugging = false

func IsDebugging():
	return _isDebugging
	
func Debug(text):
	if _isDebugging:
		print(text)
	
func Pick(array : Array):
	if array == null || array.size() == 0:
		return null

	var rand = floor(rand_range(0, array.size()))
	return array[rand]

# returns true if it can find the first case insensative match
func FindSubString(searchString, searchTerm):
	if searchString.findn(searchTerm) != -1:
		return true
	return false
	
func Rand(low, high):
	return round(rand_range(low, high))

func RandFloat(low, high):
	return rand_range(low, high)

func GetFormattedDateTimeString():
	var time : Dictionary = OS.get_datetime(true);
	var display_string : String = "%d/%02d/%02d %02d:%02d" % [time.month, time.day, time.year, time.hour, time.minute];
	return display_string

func GetFilesFromDirectory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

func GetStopWatch():
	var stopWatch = load("res://singletons/generic/utils/stopwatch.gd")
	return stopWatch.new()
	
#
# UUID HELPER FUNCTIONS BEGIN
#
const MODULO_8_BIT = 256

static func getRandomInt():
  # Randomize every time to minimize the risk of collisions
  randomize()

  return randi() % MODULO_8_BIT

static func uuidbin():
  # 16 random bytes with the bytes on index 6 and 8 modified
  return [
	getRandomInt(), getRandomInt(), getRandomInt(), getRandomInt(),
	getRandomInt(), getRandomInt(), ((getRandomInt()) & 0x0f) | 0x40, getRandomInt(),
	((getRandomInt()) & 0x3f) | 0x80, getRandomInt(), getRandomInt(), getRandomInt(),
	getRandomInt(), getRandomInt(), getRandomInt(), getRandomInt(),
  ]

static func GetUuid():
  # 16 random bytes with the bytes on index 6 and 8 modified
  var b = uuidbin()

  return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
	# low
	b[0], b[1], b[2], b[3],

	# mid
	b[4], b[5],

	# hi
	b[6], b[7],

	# clock
	b[8], b[9],

	# clock
	b[10], b[11], b[12], b[13], b[14], b[15]
  ]
#
# UUID HELPER FUNCTIONS END
#

static func sort_descending_by_second_element(a, b):
	return a[1] > b[1]
