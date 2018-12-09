###### Global Variables #######
variable "region" {
  
}
variable "Owner" {
  
}
variable "AWSaccount" {
  
}
variable "Environment" {
  
}
variable "Tag_builder" {
  
}
variable "Application" {
  
}

################### API #########

variable "path_part" {
  
}
variable "stage_name" {
  
}


###############   CDN   ###############

variable "target_origin_id" {
  
}

###############   Lambda    #############

variable "vpc_id" {
  
}
variable "subnets" {
    type = "list"
  
}
variable "route_table_ids" {
    type = "list"
  
}
variable "security_groups" {
    type = "list"
  
}
variable "http_proxy" {
  
}
variable "https_proxy" {
  
}
variable "no_proxy" {
  
}

################    AURORA    ##############

variable "name" {

}
variable "Aurora_SG_Name" {

}
variable "kms_key_id" {
  
}
variable "instance_type" {
}

variable "cluster_size" {
 
}

variable "snapshot_identifier" {
  
}

variable "db_name" {
  
}

variable "db_port" {
  
}

variable "admin_user" {
  
}

variable "admin_password" {

}

variable "retention_period" {
 
}

variable "backup_window" {
 
}

variable "maintenance_window" {
 
}

variable "tags" {
  
}

variable "cluster_parameters" {
 
}

variable "instance_parameters" {
  
}

variable "cluster_family" {

}

variable "engine" {
  
}

variable "engine_mode" {
  
}

variable "engine_version" {
 
}

variable "scaling_configuration" {
  
}

variable "allowed_cidr_blocks" {
 
}

variable "publicly_accessible" {
  
}

variable "storage_encrypted" {
 
}

variable "skip_final_snapshot" {
  
}

variable "apply_immediately" {
 
}

variable "iam_database_authentication_enabled" {
  
}

variable "rds_monitoring_interval" {
  
}

variable "rds_monitoring_role_arn" {
  
}

