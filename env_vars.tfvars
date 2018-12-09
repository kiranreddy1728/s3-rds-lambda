###### Global Variables #######
region = "us-east-1"
Owner = "KiranAWS"
AWSaccount = "" 
Environment = "dev"
Tag_builder = "Terraform v0.11.0"
Application = "RewardsAPP"

################### API #########

path_part = "rewards"
name = "rewards"
stage_name = "DEV"
  
###############   CDN   ###############

target_origin_id = "offersOrigin"

###############   Lambda    #############

vpc_id  = ""
subnets = ""
route_table_ids = ""
#security_groups = ""
//http_proxy = ""
//https_proxy = ""
//no_proxy = ""

################    AURORA    ##############

Aurora_SG_Name = "Aurora_SG"
kms_key_id = ""
instance_type = "db.r4.large"
cluster_size = "1"
snapshot_identifier = ""
db_name = "offers"
db_port = "3306"
admin_user = "admin"
admin_password = "admin1234"
retention_period = "1"
backup_window = "07:00-09:00"
maintenance_window = "wed:03:00-wed:04:00"
tags = "{}"
cluster_parameters = "[]"
instance_parameters = "[]"
cluster_family = "aurora5.6"
engine = "aurora"
engine_mode = "provisioned"
engine_version = ""
scaling_configuration = ""
allowed_cidr_blocks = "[]"
publicly_accessible = "false"
storage_encrypted = "true"
skip_final_snapshot = "true"
apply_immediately = "true"
iam_database_authentication_enabled = "true"
rds_monitoring_interval = "5"
rds_monitoring_role_arn = ""
  








