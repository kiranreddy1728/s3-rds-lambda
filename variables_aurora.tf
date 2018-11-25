# Variables for RDS
variable "name" {
  type        = "string"
  default     = "rewardsapp" 
  description = "Name of the application"
}
variable "security_groups" {
  type        = "list"
  default     = ["sg-c0aef9b2","sg-8ed581fc"]
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
  default     = "vpc-f27fde8a"
}

variable "subnets" {
  type        = "list"
  description = "List of VPC subnet IDs"
  default     = ["subnet-0544a958","subnet-09cd62afe3084fff3","subnet-074401f522af4913d"]
}

variable "instance_type" {
  type        = "string"
  default     = "db.t2.medium"
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = "string"
  default     = "1"
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = "string"
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot"
}

variable "db_name" {
  type        = "string"
  default     = "dboffers"
  description = "Database name"
}

variable "db_port" {
  type        = "string"
  default     = "3306"
  description = "Database port"
}

variable "admin_user" {
  type        = "string"
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = "string"
  default     = "admin1234"
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
  type        = "string"
  default     = "1"
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = "string"
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = "string"
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`rewards`)"
}

variable "cluster_parameters" {
  type        = "list"
  default     = []
  description = "List of DB parameters to apply"
}

variable "instance_parameters" {
  type        = "list"
  default     = []
  description = "List of DB instance parameters to apply"
}

variable "cluster_family" {
  type        = "string"
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = "string"
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = "string"
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "engine_version" {
  type        = "string"
  default     = ""
  description = "The version number of the database engine to use"
}

variable "scaling_configuration" {
  type        = "list"
  default     = []
  description = "List of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
}

variable "allowed_cidr_blocks" {
  type        = "list"
  default     = []
  description = "List of CIDR blocks allowed to access"
}

variable "publicly_accessible" {
  description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
  default     = "false"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode`"
  default     = "false"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = "true"
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = "true"
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  default     = "true"
}

variable "rds_monitoring_interval" {
  description = "Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60)"
  default     = "5"
}

variable "rds_monitoring_role_arn" {
  type        = "string"
  default     = ""
  description = "The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs"
}