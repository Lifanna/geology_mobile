BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "main_mine" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"address"	text,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"license_id"	bigint NOT NULL,
	"line_id"	bigint NOT NULL,
	"watercourse_id"	bigint NOT NULL,
	"well_id"	bigint NOT NULL,
	FOREIGN KEY("license_id") REFERENCES "main_license"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("line_id") REFERENCES "main_line"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("watercourse_id") REFERENCES "main_watercourse"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("well_id") REFERENCES "main_well"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_documentation" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"license_id"	bigint NOT NULL,
	"line_id"	bigint NOT NULL,
	"watercourse_id"	bigint NOT NULL,
	"well_id"	bigint NOT NULL,
	FOREIGN KEY("license_id") REFERENCES "main_license"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("line_id") REFERENCES "main_line"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("watercourse_id") REFERENCES "main_watercourse"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("well_id") REFERENCES "main_well"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_layer" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(255) NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"layer_material_id"	bigint NOT NULL,
	"responsible_id"	bigint NOT NULL,
	"well_id"	bigint NOT NULL,
	"comment"	text,
	"aquifer"	bool NOT NULL,
	"description"	text,
	"drilling_stopped"	bool NOT NULL,
	"sample_obtained"	bool NOT NULL,
	FOREIGN KEY("layer_material_id") REFERENCES "main_layermaterial"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("well_id") REFERENCES "main_well"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("responsible_id") REFERENCES "main_customuser"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_well" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(255) NOT NULL,
	"comment"	text,
	"description"	text,
	"line_id"	bigint,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	FOREIGN KEY("line_id") REFERENCES "main_line"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_task" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"short_name"	varchar(255) NOT NULL,
	"description"	text NOT NULL,
	"comment"	text,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"license_id"	bigint NOT NULL,
	"line_id"	bigint NOT NULL,
	"responsible_id"	bigint NOT NULL,
	"status_id"	bigint NOT NULL,
	FOREIGN KEY("license_id") REFERENCES "main_license"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("line_id") REFERENCES "main_line"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("responsible_id") REFERENCES "main_customuser"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("status_id") REFERENCES "main_taskstatus"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_welltask" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"task_id"	bigint NOT NULL,
	"well_id"	bigint NOT NULL,
	FOREIGN KEY("task_id") REFERENCES "main_task"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("well_id") REFERENCES "main_well"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_layermaterial" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(255) NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL
);
CREATE TABLE IF NOT EXISTS "main_license" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"short_name"	varchar(255) NOT NULL,
	"name"	text NOT NULL,
	"used_enginery"	text,
	"comment"	text,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"geologist_id"	bigint,
	"mbu_id"	bigint,
	"pmbou_id"	bigint,
	"status_id"	bigint NOT NULL,
	FOREIGN KEY("geologist_id") REFERENCES "main_customuser"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("mbu_id") REFERENCES "main_customuser"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("pmbou_id") REFERENCES "main_customuser"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("status_id") REFERENCES "main_licensestatus"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_linelicensewatercourse" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"license_id"	bigint NOT NULL,
	"line_id"	bigint,
	"watercourse_id"	bigint,
	FOREIGN KEY("license_id") REFERENCES "main_license"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("line_id") REFERENCES "main_line"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("watercourse_id") REFERENCES "main_watercourse"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_line" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS "main_licensewatercourse" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"license_id"	bigint NOT NULL,
	"parent_watercourse_id"	bigint,
	"watercourse_id"	bigint,
	"is_primary"	integer NOT NULL,
	FOREIGN KEY("license_id") REFERENCES "main_license"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("parent_watercourse_id") REFERENCES "main_watercourse"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("watercourse_id") REFERENCES "main_watercourse"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_customuser" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"username"	varchar(50) NOT NULL UNIQUE,
	"first_name"	varchar(50) NOT NULL,
	"last_name"	varchar(50) NOT NULL,
	"patronymic"	varchar(50) NOT NULL,
	"phone_number"	varchar(50) NOT NULL,
	"email"	varchar(255) UNIQUE,
	"is_active"	bool NOT NULL,
	"is_admin"	bool NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL,
	"role_id"	bigint NOT NULL,
	"team_id"	bigint,
	FOREIGN KEY("role_id") REFERENCES "main_role"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("team_id") REFERENCES "main_team"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "main_watercourse" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(255) NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL
);
CREATE TABLE IF NOT EXISTS "main_team" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(100) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS "main_taskstatus" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(50) NOT NULL
);
CREATE TABLE IF NOT EXISTS "main_role" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"title"	varchar(100) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS "main_licensestatus" (
	"id"	integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	varchar(255) NOT NULL,
	"created_at"	datetime NOT NULL,
	"updated_at"	datetime NOT NULL
);
CREATE INDEX IF NOT EXISTS "main_mine_well_id_6af39a8a" ON "main_mine" (
	"well_id"
);
CREATE INDEX IF NOT EXISTS "main_mine_watercourse_id_1c7cd555" ON "main_mine" (
	"watercourse_id"
);
CREATE INDEX IF NOT EXISTS "main_mine_line_id_919bac6e" ON "main_mine" (
	"line_id"
);
CREATE INDEX IF NOT EXISTS "main_mine_license_id_5f7db4ce" ON "main_mine" (
	"license_id"
);
CREATE INDEX IF NOT EXISTS "main_documentation_well_id_933779c7" ON "main_documentation" (
	"well_id"
);
CREATE INDEX IF NOT EXISTS "main_documentation_watercourse_id_d2b93671" ON "main_documentation" (
	"watercourse_id"
);
CREATE INDEX IF NOT EXISTS "main_documentation_line_id_1c14aaf7" ON "main_documentation" (
	"line_id"
);
CREATE INDEX IF NOT EXISTS "main_documentation_license_id_5b29995c" ON "main_documentation" (
	"license_id"
);
CREATE INDEX IF NOT EXISTS "main_layer_well_id_c5ea5547" ON "main_layer" (
	"well_id"
);
CREATE INDEX IF NOT EXISTS "main_layer_responsible_id_a0e19534" ON "main_layer" (
	"responsible_id"
);
CREATE INDEX IF NOT EXISTS "main_layer_layer_material_id_d13c370a" ON "main_layer" (
	"layer_material_id"
);
CREATE INDEX IF NOT EXISTS "main_well_line_id_64eb2901" ON "main_well" (
	"line_id"
);
CREATE INDEX IF NOT EXISTS "main_task_status_id_737f9dd1" ON "main_task" (
	"status_id"
);
CREATE INDEX IF NOT EXISTS "main_task_responsible_id_8607929a" ON "main_task" (
	"responsible_id"
);
CREATE INDEX IF NOT EXISTS "main_task_line_id_534e1ff6" ON "main_task" (
	"line_id"
);
CREATE INDEX IF NOT EXISTS "main_task_license_id_14ed43b4" ON "main_task" (
	"license_id"
);
CREATE INDEX IF NOT EXISTS "main_welltask_well_id_c5d08322" ON "main_welltask" (
	"well_id"
);
CREATE INDEX IF NOT EXISTS "main_welltask_task_id_8cbc5d51" ON "main_welltask" (
	"task_id"
);
CREATE INDEX IF NOT EXISTS "main_license_status_id_a44fdbf5" ON "main_license" (
	"status_id"
);
CREATE INDEX IF NOT EXISTS "main_license_pmbou_id_3d25be14" ON "main_license" (
	"pmbou_id"
);
CREATE INDEX IF NOT EXISTS "main_license_mbu_id_8268238b" ON "main_license" (
	"mbu_id"
);
CREATE INDEX IF NOT EXISTS "main_license_geologist_id_5e8f1352" ON "main_license" (
	"geologist_id"
);
CREATE INDEX IF NOT EXISTS "main_linelicensewatercourse_watercourse_id_f6e21b8c" ON "main_linelicensewatercourse" (
	"watercourse_id"
);
CREATE INDEX IF NOT EXISTS "main_linelicensewatercourse_line_id_bfd57d36" ON "main_linelicensewatercourse" (
	"line_id"
);
CREATE INDEX IF NOT EXISTS "main_linelicensewatercourse_license_id_5e240256" ON "main_linelicensewatercourse" (
	"license_id"
);
CREATE INDEX IF NOT EXISTS "main_licencewatercourse_watercourse_id_844dd40a" ON "main_licensewatercourse" (
	"watercourse_id"
);
CREATE INDEX IF NOT EXISTS "main_licencewatercourse_parent_watercourse_id_89ace980" ON "main_licensewatercourse" (
	"parent_watercourse_id"
);
CREATE INDEX IF NOT EXISTS "main_licencewatercourse_license_id_ad507667" ON "main_licensewatercourse" (
	"license_id"
);
CREATE INDEX IF NOT EXISTS "main_customuser_team_id_6c617344" ON "main_customuser" (
	"team_id"
);
CREATE INDEX IF NOT EXISTS "main_customuser_role_id_7d2f53fa" ON "main_customuser" (
	"role_id"
);
COMMIT;
