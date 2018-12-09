
# Aurora Cluster creation
resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier                  = "${var.name}-${var.Environment}-rds-auroracluster"
  database_name                       = "${var.db_name}"
  master_username                     = "${var.admin_user}"
  master_password                     = "${data.aws_ssm_parameter.aurora_master_passwd_ssm.value}"
  backup_retention_period             = "${var.retention_period}"
  preferred_backup_window             = "${var.backup_window}"
  final_snapshot_identifier           = "${var.name}-${var.Environment}-rds-cluster-snapshot"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  apply_immediately                   = "${var.apply_immediately}"
  storage_encrypted                   = "${var.storage_encrypted}"
  kms_key_id                          = "${var.kms_key_id}"
  snapshot_identifier                 = "${var.snapshot_identifier}" 
  preferred_maintenance_window        = "${var.maintenance_window}"
  vpc_security_group_ids              = ["${aws_security_group.aurorarewards-sg.id}"]  //["${aws_security_group.default.id}"] 
  db_subnet_group_name                = "${aws_db_subnet_group.rewards.name}"
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.rewards.name}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  //engine                              = "${var.engine}"
  //engine_version                      = "${var.engine_version}"
  //engine_mode                         = "${var.engine_mode}"
  //scaling_configuration               = "${var.scaling_configuration}"
  //iam_roles                           = ["${aws_iam_role.rewards_RDSLoadFromS3.arn}"]
}

# Aurora Instance creation

resource "aws_rds_cluster_instance" "rds_instance" {
  count                   = 1
  identifier              = "${var.name}-${var.Environment}-rds-instance-${count.index}"
  cluster_identifier      = "${aws_rds_cluster.rds_cluster.id}"
  instance_class          = "${var.instance_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.rewards.name}"
  db_parameter_group_name = "${aws_db_parameter_group.aurora_instance_param_group.name}"
  publicly_accessible     = "${var.publicly_accessible}"
  //engine                  = "${var.engine}"
  //engine_version          = "${var.engine_version}"
  //monitoring_interval     = "${var.rds_monitoring_interval}"
  //monitoring_role_arn     = "${aws_iam_role.enhanced_monitoring.arn}"
}

# DB subnet parameter group 
resource "aws_db_subnet_group" "rewards" {
  description = "Allowed subnets for DB cluster instances"
  name = "${var.name}-${var.Environment}-db-subnet-grp"
  subnet_ids  = ["${var.subnets}"]

  tags {
      Name = "DBSubnet Group"
  }
  
}

# DB Cluster parameter group
resource "aws_rds_cluster_parameter_group" "rewards" {
  description = "DB cluster parameter group"
  family      = "${var.cluster_family}"
  name        = "${var.name}-${var.Environment}-rds-cluster-param-grp" 
  parameter {
      name = "aurora_load_from_s3_role"
      value = "arn:aws:iam::${var.AWSaccount}:role/rewardsRDSLoadFromS3"
  }
   parameter {
      name = "aws_default_s3_role"
      value = "arn:aws:iam::${var.AWSaccount}:role/rewardsRDSLoadFromS3"
  }
  tags {
      Name = "DB cluster parameter group"
  }
}


# DB Instance parameter group
resource "aws_db_parameter_group" "aurora_instance_param_group" {
  description = "DB instance parameter group"
  family      = "${var.cluster_family}"
  name        = "${var.name}-${var.Environment}-db-instance-param-grp" 
  
  parameter {
      name = "event_scheduler"
      value = "ON"
  }
  tags {
      Name = "aurora_instance_param_group"
  } 
}

data "aws_ssm_parameter" "aurora_master_passwd_ssm" {
  name = "rewardsAppDBPassword"
}

#outputs

output "aurora_endpoint" {
  value = "${aws_rds_cluster.rds_cluster.endpoint}"
}

output "aurora_resource_id" {
  value = "${aws_rds_cluster.rds_cluster.cluster_resource_id}"
}

output "aurora_db_cluster" {
  value = "${aws_rds_cluster.rds_cluster.cluster_identifier}"
}

output "aurora_pass" {
  value = "${data.aws_ssm_parameter.aurora_master_passwd_ssm.value}"
}







