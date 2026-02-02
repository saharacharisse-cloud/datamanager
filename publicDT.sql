/*
 Navicat Premium Dump SQL

 Source Server         : SSP
 Source Server Type    : PostgreSQL
 Source Server Version : 150014 (150014)
 Source Host           : localhost:5432
 Source Catalog        : Datamanager
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150014 (150014)
 File Encoding         : 65001

 Date: 20/01/2026 09:47:23
*/

-- ----------------------------
-- Sequence structure for sys_notice_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sys_notice_id_seq";
CREATE SEQUENCE "public"."sys_notice_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for sys_user_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sys_user_id_seq";
CREATE SEQUENCE "public"."sys_user_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for sys_user_workdir_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."sys_user_workdir_id_seq";
CREATE SEQUENCE "public"."sys_user_workdir_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for unique_code_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."unique_code_id_seq";
CREATE SEQUENCE "public"."unique_code_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for user_attendance_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."user_attendance_id_seq";
CREATE SEQUENCE "public"."user_attendance_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for workload_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."workload_id_seq";
CREATE SEQUENCE "public"."workload_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_notice";
CREATE TABLE "public"."sys_notice" (
  "id" int4 NOT NULL DEFAULT nextval('sys_notice_id_seq'::regclass),
  "user_uuid" uuid NOT NULL,
  "publish_topic" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "publish_content" text COLLATE "pg_catalog"."default" NOT NULL,
  "publish_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "url" varchar(512) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_user";
CREATE TABLE "public"."sys_user" (
  "id" int4 NOT NULL DEFAULT nextval('sys_user_id_seq'::regclass),
  "user_uuid" uuid NOT NULL DEFAULT gen_random_uuid(),
  "password" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "role" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "create_time" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "creator" varchar(100) COLLATE "pg_catalog"."default",
  "user_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "full_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for sys_user_workdir
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_user_workdir";
CREATE TABLE "public"."sys_user_workdir" (
  "id" int4 NOT NULL DEFAULT nextval('sys_user_workdir_id_seq'::regclass),
  "user_uuid" uuid NOT NULL DEFAULT gen_random_uuid(),
  "alias" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "parent_workdir" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "workdir0" varchar(500) COLLATE "pg_catalog"."default",
  "workdir1" varchar(500) COLLATE "pg_catalog"."default",
  "workdir2" varchar(500) COLLATE "pg_catalog"."default",
  "workdir3" varchar(500) COLLATE "pg_catalog"."default",
  "workdir4" varchar(500) COLLATE "pg_catalog"."default",
  "workdir5" varchar(500) COLLATE "pg_catalog"."default",
  "workdir6" varchar(500) COLLATE "pg_catalog"."default",
  "workdir7" varchar(500) COLLATE "pg_catalog"."default",
  "workdir8" varchar(500) COLLATE "pg_catalog"."default",
  "workdir9" varchar(500) COLLATE "pg_catalog"."default",
  "workdir0_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir1_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir2_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir3_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir4_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir5_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir6_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir7_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir8_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir9_status" varchar(30) COLLATE "pg_catalog"."default",
  "workdir0_status_time" timestamptz(6),
  "workdir1_status_time" timestamptz(6),
  "workdir2_status_time" timestamptz(6),
  "workdir3_status_time" timestamptz(6),
  "workdir4_status_time" timestamptz(6),
  "workdir5_status_time" timestamptz(6),
  "workdir6_status_time" timestamptz(6),
  "workdir7_status_time" timestamptz(6),
  "workdir8_status_time" timestamptz(6),
  "workdir9_status_time" timestamptz(6),
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "work_type" varchar(255) COLLATE "pg_catalog"."default"
);

-- ----------------------------
-- Table structure for unique_code
-- ----------------------------
DROP TABLE IF EXISTS "public"."unique_code";
CREATE TABLE "public"."unique_code" (
  "id" int4 NOT NULL DEFAULT nextval('unique_code_id_seq'::regclass),
  "code_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "user_uuid" uuid,
  "modifier" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "modify_time" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Table structure for user_attendance
-- ----------------------------
DROP TABLE IF EXISTS "public"."user_attendance";
CREATE TABLE "public"."user_attendance" (
  "id" int4 NOT NULL DEFAULT nextval('user_attendance_id_seq'::regclass),
  "user_uuid" uuid NOT NULL DEFAULT gen_random_uuid(),
  "morning_check_time" timestamp(6),
  "afternoon_check_time" timestamp(6),
  "evening_check_time" timestamp(6),
  "check_date" date NOT NULL DEFAULT CURRENT_DATE
)
;

-- ----------------------------
-- Table structure for workload
-- ----------------------------
DROP TABLE IF EXISTS "public"."workload";
CREATE TABLE "public"."workload" (
  "id" int4 NOT NULL DEFAULT nextval('workload_id_seq'::regclass),
  "user_uuid" uuid NOT NULL,
  "work_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "work_content" json NOT NULL,
  "description" varchar(500) COLLATE "pg_catalog"."default",
  "create_time" timestamptz(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Function structure for armor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."armor"(bytea);
CREATE FUNCTION "public"."armor"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for armor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."armor"(bytea, _text, _text);
CREATE FUNCTION "public"."armor"(bytea, _text, _text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_armor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for crypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."crypt"(text, text);
CREATE FUNCTION "public"."crypt"(text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_crypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for dearmor
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."dearmor"(text);
CREATE FUNCTION "public"."dearmor"(text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_dearmor'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."decrypt"(bytea, bytea, text);
CREATE FUNCTION "public"."decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for decrypt_iv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."decrypt_iv"(bytea, bytea, bytea, text);
CREATE FUNCTION "public"."decrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_decrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for digest
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."digest"(bytea, text);
CREATE FUNCTION "public"."digest"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for digest
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."digest"(text, text);
CREATE FUNCTION "public"."digest"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_digest'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."encrypt"(bytea, bytea, text);
CREATE FUNCTION "public"."encrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for encrypt_iv
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."encrypt_iv"(bytea, bytea, bytea, text);
CREATE FUNCTION "public"."encrypt_iv"(bytea, bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_encrypt_iv'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_random_bytes
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_random_bytes"(int4);
CREATE FUNCTION "public"."gen_random_bytes"(int4)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_random_bytes'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_random_uuid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_random_uuid"();
CREATE FUNCTION "public"."gen_random_uuid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/pgcrypto', 'pg_random_uuid'
  LANGUAGE c VOLATILE
  COST 1;

-- ----------------------------
-- Function structure for gen_salt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_salt"(text, int4);
CREATE FUNCTION "public"."gen_salt"(text, int4)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt_rounds'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for gen_salt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."gen_salt"(text);
CREATE FUNCTION "public"."gen_salt"(text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pg_gen_salt'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hmac
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hmac"(text, text, text);
CREATE FUNCTION "public"."hmac"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for hmac
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."hmac"(bytea, bytea, text);
CREATE FUNCTION "public"."hmac"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pg_hmac'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_armor_headers
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_armor_headers"(text, OUT "key" text, OUT "value" text);
CREATE FUNCTION "public"."pgp_armor_headers"(IN text, OUT "key" text, OUT "value" text)
  RETURNS SETOF "pg_catalog"."record" AS '$libdir/pgcrypto', 'pgp_armor_headers'
  LANGUAGE c IMMUTABLE STRICT
  COST 1
  ROWS 1000;

-- ----------------------------
-- Function structure for pgp_key_id
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_key_id"(bytea);
CREATE FUNCTION "public"."pgp_key_id"(bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_key_id_w'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text);
CREATE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea);
CREATE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt"(bytea, bytea, text, text);
CREATE FUNCTION "public"."pgp_pub_decrypt"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text);
CREATE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text, text);
CREATE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_decrypt_bytea"(bytea, bytea);
CREATE FUNCTION "public"."pgp_pub_decrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea);
CREATE FUNCTION "public"."pgp_pub_encrypt"(text, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt"(text, bytea, text);
CREATE FUNCTION "public"."pgp_pub_encrypt"(text, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea, text);
CREATE FUNCTION "public"."pgp_pub_encrypt_bytea"(bytea, bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_pub_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_pub_encrypt_bytea"(bytea, bytea);
CREATE FUNCTION "public"."pgp_pub_encrypt_bytea"(bytea, bytea)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text);
CREATE FUNCTION "public"."pgp_sym_decrypt"(bytea, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt"(bytea, text, text);
CREATE FUNCTION "public"."pgp_sym_decrypt"(bytea, text, text)
  RETURNS "pg_catalog"."text" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text, text);
CREATE FUNCTION "public"."pgp_sym_decrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_decrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_decrypt_bytea"(bytea, text);
CREATE FUNCTION "public"."pgp_sym_decrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text, text);
CREATE FUNCTION "public"."pgp_sym_encrypt"(text, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt"(text, text);
CREATE FUNCTION "public"."pgp_sym_encrypt"(text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text, text);
CREATE FUNCTION "public"."pgp_sym_encrypt_bytea"(bytea, text, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Function structure for pgp_sym_encrypt_bytea
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."pgp_sym_encrypt_bytea"(bytea, text);
CREATE FUNCTION "public"."pgp_sym_encrypt_bytea"(bytea, text)
  RETURNS "pg_catalog"."bytea" AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea'
  LANGUAGE c VOLATILE STRICT
  COST 1;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."sys_notice_id_seq"
OWNED BY "public"."sys_notice"."id";
SELECT setval('"public"."sys_notice_id_seq"', 13, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."sys_user_id_seq"
OWNED BY "public"."sys_user"."id";
SELECT setval('"public"."sys_user_id_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."sys_user_workdir_id_seq"
OWNED BY "public"."sys_user_workdir"."id";
SELECT setval('"public"."sys_user_workdir_id_seq"', 48, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."unique_code_id_seq"
OWNED BY "public"."unique_code"."id";
SELECT setval('"public"."unique_code_id_seq"', 102, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."user_attendance_id_seq"
OWNED BY "public"."user_attendance"."id";
SELECT setval('"public"."user_attendance_id_seq"', 13, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."workload_id_seq"
OWNED BY "public"."workload"."id";
SELECT setval('"public"."workload_id_seq"', 35, true);

-- ----------------------------
-- Primary Key structure for table sys_notice
-- ----------------------------
ALTER TABLE "public"."sys_notice" ADD CONSTRAINT "sys_notice_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table sys_user
-- ----------------------------
CREATE INDEX "idx_sys_user_creator" ON "public"."sys_user" USING btree (
  "creator" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_sys_user_status" ON "public"."sys_user" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_sys_user_user_uuid" ON "public"."sys_user" USING btree (
  "user_uuid" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table sys_user
-- ----------------------------
ALTER TABLE "public"."sys_user" ADD CONSTRAINT "sys_user_user_uuid_key" UNIQUE ("user_uuid");

-- ----------------------------
-- Checks structure for table sys_user
-- ----------------------------
ALTER TABLE "public"."sys_user" ADD CONSTRAINT "sys_user_status_check" CHECK (status::text = ANY (ARRAY['激活'::character varying, '暂停'::character varying, '删除'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table sys_user
-- ----------------------------
ALTER TABLE "public"."sys_user" ADD CONSTRAINT "sys_user_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table sys_user_workdir
-- ----------------------------
CREATE INDEX "idx_sys_user_workdir_parent" ON "public"."sys_user_workdir" USING btree (
  "parent_workdir" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_sys_user_workdir_uuid" ON "public"."sys_user_workdir" USING btree (
  "user_uuid" "pg_catalog"."uuid_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table sys_user_workdir
-- ----------------------------
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir0_status_check" CHECK (workdir0_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir1_status_check" CHECK (workdir1_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir2_status_check" CHECK (workdir2_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir3_status_check" CHECK (workdir3_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir7_status_check" CHECK (workdir7_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir5_status_check" CHECK (workdir5_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir6_status_check" CHECK (workdir6_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir9_status_check" CHECK (workdir9_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir4_status_check" CHECK (workdir4_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_workdir8_status_check" CHECK (workdir8_status::text = ANY (ARRAY['新任务'::character varying::text, '标注中'::character varying::text, '提交'::character varying::text, '返工'::character varying::text, '转交'::character varying::text, '审核中'::character varying::text, '已审核'::character varying::text, '完成'::character varying::text, '重启'::character varying::text]));

-- ----------------------------
-- Primary Key structure for table sys_user_workdir
-- ----------------------------
ALTER TABLE "public"."sys_user_workdir" ADD CONSTRAINT "sys_user_workdir_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table unique_code
-- ----------------------------
ALTER TABLE "public"."unique_code" ADD CONSTRAINT "unique_code_code_name_key" UNIQUE ("code_name");

-- ----------------------------
-- Checks structure for table unique_code
-- ----------------------------
ALTER TABLE "public"."unique_code" ADD CONSTRAINT "unique_code_status_check" CHECK (status::text = ANY (ARRAY['激活'::character varying, '挂起'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table unique_code
-- ----------------------------
ALTER TABLE "public"."unique_code" ADD CONSTRAINT "unique_code_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table user_attendance
-- ----------------------------
CREATE INDEX "idx_attendance_check_date" ON "public"."user_attendance" USING btree (
  "check_date" "pg_catalog"."date_ops" DESC NULLS FIRST
);

-- ----------------------------
-- Uniques structure for table user_attendance
-- ----------------------------
ALTER TABLE "public"."user_attendance" ADD CONSTRAINT "unique_user_date" UNIQUE ("user_uuid", "check_date");
ALTER TABLE "public"."user_attendance" ADD CONSTRAINT "unique_user_attendance_date" UNIQUE ("user_uuid", "check_date");

-- ----------------------------
-- Primary Key structure for table user_attendance
-- ----------------------------
ALTER TABLE "public"."user_attendance" ADD CONSTRAINT "user_attendance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table workload
-- ----------------------------
CREATE INDEX "idx_workload_create_time" ON "public"."workload" USING btree (
  "create_time" "pg_catalog"."timestamptz_ops" ASC NULLS LAST
);
CREATE INDEX "idx_workload_user_uuid" ON "public"."workload" USING btree (
  "user_uuid" "pg_catalog"."uuid_ops" ASC NULLS LAST
);
CREATE INDEX "idx_workload_work_type" ON "public"."workload" USING btree (
  "work_type" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table workload
-- ----------------------------
ALTER TABLE "public"."workload" ADD CONSTRAINT "workload_work_type_check" CHECK (work_type::text = ANY (ARRAY['清理'::character varying::text, '抽帧'::character varying::text, '筛图'::character varying::text, '分工'::character varying::text, '转换'::character varying::text, '改名'::character varying::text, '转移'::character varying::text, '标注'::character varying::text, '核查'::character varying::text, '训练'::character varying::text, '测试'::character varying::text]));

-- ----------------------------
-- Primary Key structure for table workload
-- ----------------------------
ALTER TABLE "public"."workload" ADD CONSTRAINT "workload_pkey" PRIMARY KEY ("id");
