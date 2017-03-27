# This is not fully implemented - user_data needs to handle it somehow
variable "data_location" {
	type = "string"
}

variable "environment_name" {
	type = "string"
}

# variable "cluster_id" {
# 	type = "string"
# }

# Desired number of running tasks
variable "desired_count" {
	type = "string"
}

######## MINECRAFT ENVIRONMENT VARIABLES

variable "allow_nether" {
	default = "true"
	type = "string"
}
variable "difficulty" {
	default = "normal"
	type = "string"
}
variable "enable_command_block" {
	default = "false"
	type = "string"
}
variable "force_gamemode" {
	default = ""
	type = "string"
}
variable "ftb_server_mod" {
	default = ""
	type = "string"
}
variable "generate_structures" {
	default = ""
	type = "string"
}
variable "hardcore" {
	default = ""
	type = "string"
}
variable "icon" {
	default = ""
	type = "string"
}
variable "level" {
	default = ""
	type = "string"
}
variable "level_type" {
	default = ""
	type = "string"
}
variable "max_build_height" {
	default = ""
	type = "string"
}
variable "max_ram" {
	default = ""
	type = "string"
}
variable "max_tick_time" {
	default = ""
	type = "string"
}
variable "min_ram" {
	default = ""
	type = "string"
}
variable "mode" {
	default = ""
	type = "string"
}
variable "modpack" {
	default = ""
	type = "string"
}
variable "motd" {
	default = ""
	type = "string"
}
variable "ops" {
	default = ""
	type = "string"
}
variable "permgen_size" {
	default = ""
	type = "string"
}
variable "pvp" {
	default = ""
	type = "string"
}
variable "seed" {
	default = ""
	type = "string"
}
variable "spawn_animals" {
	default = ""
	type = "string"
}
variable "spawn_monsters" {
	default = ""
	type = "string"
}
variable "spawn_npcs" {
	default = ""
	type = "string"
}
variable "type" {
	default = ""
	type = "string"
}
variable "view_distance" {
	default = ""
	type = "string"
}
variable "whitelist" {
	default = ""
	type = "string"
}
variable "world" {
	default = "world"
	type = "string"
}
variable "memory" {
	default = "800M"
	type = "string"
}
variable "max_memory" {
	default = "800M"
	type = "string"
}
variable "max_memory_server" {
	default = "900"
	type = "string"
}
variable "mc_container_port" {
	default = "25565"
	type = "string"
}
variable "rcon_container_port" {
	default = "28016"
	type = "string"
}
variable "mc_host_port" {
	default = "0"
	type = "string"
}
variable "rcon_host_port" {
	default = "0"
	type = "string"
}

######### END
