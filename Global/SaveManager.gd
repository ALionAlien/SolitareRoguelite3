extends Node

const encrypted_path := "user://save_encrypted.data"
const temp_path := "user://temp_load.tres"
var data : SaveData

func _ready():
	await get_tree().process_frame
	if save_exists():
		load_save()
	else:
		data = SaveData.new()
		data.create_empty_save()

func save_game() -> void:
	get_tree().call_group("save", "save_data")
	save_encrypted_resource(data, encrypted_path, get_encryption_password())
	
func load_save() -> void:
	if not FileAccess.file_exists(encrypted_path):
		return
	data = load_encrypted_resource(encrypted_path, get_encryption_password())
	get_tree().call_group("save", "load_data")

func save_exists() -> bool:
	if FileAccess.file_exists(encrypted_path):
		return true
	else:
		return false

func delete_save()->void:
	if FileAccess.file_exists(encrypted_path):
		var error = DirAccess.remove_absolute(encrypted_path)
		if error == OK:
			print("Save file deleted successfully: ", encrypted_path)
		else:
			print("Failed to delete save file, error code: ", error)
	else:
		print("Save file not found: ", encrypted_path)
func save_encrypted_resource(resource: Resource, _path: String, password: String) -> void:
	#save resource in temporary file
	ResourceSaver.save(resource, temp_path)
	
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
	#use password to open the encrypted file in read mode
	var file = FileAccess.open_encrypted_with_pass(_path, FileAccess.READ, password)
	
	#return nothing if it fails to load
	if not file:
		push_error("failed to open encrypted file")
		return null
	
	#retrieve the buffer from the encrypted save file
	var buffer = file.get_buffer(file.get_length())
	file.close()
	
	#open a temporary file and store the buffer of the encrypted file
	var temp_file = FileAccess.open(temp_path, FileAccess.WRITE)
	temp_file.store_buffer(buffer)
	temp_file.close()
	
	#load the resource temporary file then delete it
	var res = ResourceLoader.load(temp_path)
	DirAccess.remove_absolute(temp_path)
	
	#return the resource from temporary file
	return res

func get_encryption_password():
	#salt refers to random data added before it gets hashed
	#salt should be generated in game, NEVER hardcode salt
	var salt = "Pass"
	#convert the password into a hash string making it harder to decipher
	#OS id is unique to device so saves from other devices cannot be loaded
	#OS id might change if user raplaces hardware making their saves unaccessable
	var password = (salt + OS.get_unique_id().sha256_text())
	
	return password
