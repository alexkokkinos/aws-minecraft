provider "aws" {
	region = "us-east-1"
}

resource "aws_ecs_cluster" "minecraft" {
	name = "${var.environment_name}"
}

module "ecs_instance" {
	source = "../server"
	ami = "ami-b2df2ca4"
	instance_type = "t2.micro"
	user_data = "${data.template_file.user_data.rendered}"
	fqdn = "${var.fqdn}"
	tag_name = "ecs instance"
}

data "template_file" "user_data" {
	template = "${file("../modules/ecs-tenant/files/user_data")}"
	vars {
		cluster = "${var.environment_name}"
	}
}

data "template_file" "task_definition_json" {
    template = "${file("../modules/ecs-tenant/files/def.json")}"

    vars {
		ALLOW_NETHER = "${var.allow_nether}"
		DIFFICULTY = "${var.difficulty}"
		ENABLE_COMMAND_BLOCK = "${var.enable_command_block}"
		FORCE_GAMEMODE = "${var.force_gamemode}"
		FTB_SERVER_MOD = "${var.ftb_server_mod}"
		GENERATE_STRUCTURES = "${var.generate_structures}"
		HARDCORE = "${var.hardcore}"
		ICON = "${var.icon}"
		LEVEL = "${var.level}"
		LEVEL_TYPE = "${var.level_type}"
		MAX_BUILD_HEIGHT = "${var.max_build_height}"
		MAX_RAM = "${var.max_ram}"
		MAX_TICK_TIME = "${var.max_tick_time}"
		MIN_RAM = "${var.min_ram}"
		MODE = "${var.mode}"
		MODPACK = "${var.modpack}"
		MOTD = "${var.motd}"
		OPS = "${var.ops}"
		PERMGEN_SIZE = "${var.permgen_size}"
		PVP = "${var.pvp}"
		SEED = "${var.seed}"
		SPAWN_ANIMALS = "${var.spawn_animals}"
		SPAWN_MONSTERS = "${var.spawn_monsters}"
		SPAWN_NPCS = "${var.spawn_npcs}"
		TYPE = "${var.type}"
		VIEW_DISTANCE = "${var.view_distance}"
		WHITELIST = "${var.whitelist}"
		WORLD = "${var.world}"
		MEMORY = "${var.memory}"
        MAX_MEMORY = "${var.max_memory}"
        MAX_MEMORY_SERVER = "${var.max_memory_server}"
        MC_HOST_PORT = "${var.mc_host_port}"
        MC_CONTAINER_PORT = "${var.mc_container_port}"
        RCON_PASSWORD = "${var.rcon_password}"
        RCON_HOST_PORT = "${var.rcon_host_port}"
        RCON_CONTAINER_PORT = "${var.rcon_container_port}"
    }
}

resource "aws_ecs_task_definition" "mc-task" {
	family = "minecraft-${var.environment_name}"
	container_definitions = "${data.template_file.task_definition_json.rendered}"
	volume {
		name = "data"
		host_path = "/${var.data_location}/"
	}
}

resource "aws_ecs_service" "minecraft" {
  name = "${var.environment_name}"
  cluster = "${var.environment_name}"
  task_definition = "${aws_ecs_task_definition.mc-task.arn}"
  desired_count = 1
}
