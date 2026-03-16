extends Node

const encrypted_path := "user://save_encrypted.dat"
const temp_path := "user://temp_load.tres"
var data : SaveData

func _ready()->void:
	data = SaveData.new()

func new_save()->void:
	if save_exists():
		delete_save()
	data = SaveData.new()
	save_game()

func save_game() -> void:
	get_tree().call_group("save", "save_data")
	save_encrypted_resource(data, encrypted_path, get_encryption_password())

func load_game() -> void:
	if save_exists():
		data = load_encrypted_resource(encrypted_path, get_encryption_password())
		get_tree().call_group("save", "load_data")

func save_exists() -> bool:
	return FileAccess.file_exists(encrypted_path)

func delete_save()->void:
	if FileAccess.file_exists(encrypted_path):
		var error = DirAccess.remove_absolute(encrypted_path)
		if error == OK:
			print("Save file deleted successfully: ", encrypted_path)
		else:
			print("Failed to delete save file, error code: ", error)
	else:
		print("Save file not found: ", encrypted_path)

func save_encrypted_resource(resource: SaveData, _path: String, password: String) -> void:
	var copy_res : SaveData = resource.duplicate()
	#save resource in temporary file
	ResourceSaver.save(copy_res, temp_path)
	
	#get the buffer of the temp file as read only and close it
	var file = FileAccess.open(temp_path, FileAccess.READ)
	var buffer = file.get_buffer(file.get_length())
	file.close()
	
	#use the password to open an encrypted file and store the buffer
	var encrypted_file = FileAccess.open_encrypted_with_pass(_path, FileAccess.WRITE, password)
	encrypted_file.store_buffer(buffer)
	encrypted_file.close()
	
	#delete the temporary file
	DirAccess.remove_absolute(temp_path)
	
func load_encrypted_resource(_path: String, password: String) -> Resource:
	var file = FileAccess.open_encrypted_with_pass(_path, FileAccess.READ, password)
	if not file:
		push_error("Failed to open encrypted file.")
		return null
 
	var buffer = file.get_buffer(file.get_length())
	file.close()
 
	var temp_file = FileAccess.open(temp_path, FileAccess.WRITE)
	temp_file.store_buffer(buffer)
	temp_file.close()
 
	var res = ResourceLoader.load(temp_path)
	DirAccess.remove_absolute(temp_path)
 
	return res

func get_encryption_password():
	#salt refers to random data added before it gets hashed
	#salt should be generated in game, NEVER hardcode salt
	var salt = "Password"
	#convert the password into a hash string making it harder to decipher
	#OS id is unique to device so saves from other devices cannot be loaded
	#OS id might change if user raplaces hardware making their saves unaccessable
	var password = (salt + OS.get_unique_id().sha256_text())
	
	return password
