# CommandRunner class registers and runs commands.
#
# A command is a string with the command id first, then arguments separated by spaces.
# Format : command_id arg1 arg2 ...
# Example : echo bonjour!gg
#
# It can be useful for debug console, or basic scripting
# (I'm using it to parse and run custom commands in the Ink scripting language).
#
# How to use :
# Add this script as an autoload in 'Project/ProjectSettings/Autoload'
# Register new commands like :
#	CommandParser.register_command("command ID", object, "method", 1, 1, "docs", "one-line docs")
# And parse them :
#	CommandParser.run_command(command_got_from_ink_file)


extends Node

# Simple structure containing all data about a command.
class Command:
	var command_id: String
	var object
	var function_id: String
	var required_args_count: int
	var max_args_count: int
	var docs: String
	var help: String
	
	func _init(_com_id, _obj, _func_id, _required_args_count, _max_args_count, 
	_docs, _help):
		assert(_required_args_count <= _max_args_count)
		command_id = _com_id
		function_id = _func_id
		object = _obj
		required_args_count = _required_args_count
		max_args_count = _max_args_count
		docs = _docs
		help = _help

var registered_commands_per_id: Dictionary

# Parse the given command and run it.
func run_command(str_command : String) -> void:
	var args: PoolStringArray = str_command.split(" ", false)
	if args.empty():
		push_error("Command is empty string.")
	var command_id: String = args[0]
	args.remove(0)
	if not registered_commands_per_id.has(command_id):
		push_error("Command '%s' is not registered." % command_id)
		return
	var command := registered_commands_per_id[command_id] as Command
		
	# Check arguments count.
	var args_count = args.size() 
	if args_count < command.required_args_count:
		push_error("Command '%s' expected at least %d arguments, only %d provided." %
				[command_id, command.required_args_count, args_count])
		return
	if args_count > command.max_args_count:
		push_error("Command '%s' expected %d arguments max, %d provided." %
			[command_id, command.max_args_count, args_count])
		return

	command.object.callv(command_id, args)

# Register the command, if command already exists, it is overwritten.
# TODO instead of overwriten, if the command has same param then juste add it to the objects to call.
func register_command(command_id: String, obj, function_id: String, 
		required_args_count: int, max_args_count: int, docs: String, 
		help: String) -> void:
	if registered_commands_per_id.has(command_id):
		push_warning("Command '%s' already exists. Existing command is ovewritten." % command_id)
	if not obj.has_method(function_id):
		push_error("Object '%s' does not have '%s' function." % [obj.to_string(), function_id])
		return
	registered_commands_per_id[command_id] = Command.new(command_id, obj, 
			function_id, required_args_count, max_args_count, docs, help)

func unregister_command(command_id: String) -> void:
	if not registered_commands_per_id.erase(command_id):
		push_warning("Trying to unregister unknown command '%s'." % command_id)
		
