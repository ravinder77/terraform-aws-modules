variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "identifier" {
  description = "Unique identifier for the RDS instance."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.identifier))
    error_message = "identifier must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}


variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

#----- Engine -----
variable "engine" {
  description = "Database engine."
  type        = string
  default     = "postgres"

  validation {
    condition     = contains(["postgres", "mysql", "mariadb"], var.engine)
    error_message = "engine must be one of: postgres, mysql, mariadb."
  }
}

variable "engine_version" {
  description = "Database engine version."
  type        = string
  default     = "17"
}

variable "major_engine_version" {
  description = "Major engine version for option group"
  type        = string
  default     = "15"
}


variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.medium"
}

variable "license_model" {
  description = "Optional license model for the DB engine."
  type        = string
  default     = null
}

#------Storage -------
variable "allocated_storage" {
  description = "Initial storage allocation in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage must be at least 20 GiB."
  }
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB. Set to 0 to disable autoscaling."
  type        = number
  default     = 100

  validation {
    condition     = var.max_allocated_storage == 0 || var.max_allocated_storage >= var.allocated_storage
    error_message = "max_allocated_storage must be 0 or greater than or equal to allocated_storage."
  }
}

variable "storage_type" {
  description = "Storage type for the primary instance."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "storage_type must be one of: gp2, gp3, io1."
  }
}

variable "iops" {
  description = "Provisioned IOPS (required for io1/io2)"
  type = number
  default = null
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS Key ARN for storage encryption"
  type        = string
  default     = null
}

# ----- Credentials--------
variable "db_name" {
  description = "Initial database name."
  type        = string
}

variable "username" {
  description = "Master database username."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

# ------- Network -------
variable "vpc_id" {
  description = "VPC ID used by the RDS security group."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "create_db_subnet_group" {
  description = "Whether to create a DB subnet group"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "Existing DB subnet group name (used if create_db_subnet_group = false)"
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment."
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "AZ for single-AZ deployment"
  type        = string
  default     = null
}

# ----Security Group -------
variable "create_security_group" {
  description = "Whether to create a security group for the RDS instance"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the DB port"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to the DB"
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the RDS instance"
  type        = list(string)
  default     = []
}

#------ Parameter & Option Groups --------

variable "create_db_parameter_group" {
  description = "Whether to create a DB parameter group"
  type        = bool
  default     = true
}

variable "db_parameter_group_name" {
  description = "Existing parameter group name (used if create_db_parameter_group = false)"
  type        = string
  default     = null
}

variable "parameter_group_family" {
  description = "DB parameter group family (e.g. postgres15, mysql8.0)"
  type        = string
  default     = "postgres15"
}

variable "parameters" {
  description = "List of parameter maps {name, value, apply_method}"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "create_db_option_group" {
  description = "Whether to create a DB option group (MySQL/MariaDB)"
  type        = bool
  default     = false
}

variable "db_option_group_name" {
  description = "Existing option group name (used if create_db_option_group = false)"
  type        = string
  default     = null
}

variable "options" {
  description = "List of options for the DB option group"
  type        = any
  default     = []
}

# ----Backups--------

variable "backup_retention_period" {
  description = "Number of days to retain backup (0 disables backup)."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 0 and 35."
  }
}

variable "backup_window" {
  description = "Preferred daily backup window in UTC."
  type        = string
  default     = "03:00-04:00"
}

variable "delete_automated_backups" {
  description = "Whether to delete automated backups on instance deletion"
  type        = bool
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "Copy all instance tags to snapshots"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip a final snapshot on destroy."
  type        = bool
  default     = false
}

# -------Maintenance------
variable "maintenance_window" {
  description = "Weekly maintenance window, e.g. Mon:05:00-Mon:06:00"
  type        = string
  default     = "Mon:05:00-Mon:06:00"
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately or during maintenance window"
  type        = bool
  default     = false
}

#----- Monitoring -------
variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 60

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "monitoring_interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "create_monitoring_role" {
  description = "Create IAM role for enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_role_arn" {
  description = "IAM role ARN used for enhanced monitoring. Required when monitoring_interval > 0."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Log types to export to CloudWatch (e.g. postgresql, upgrade, error, slowquery)"
  type        = list(string)
  default     = ["postgresql"]
}

variable "performance_insights_enabled" {
  description = "Whether to enable Performance Insights."
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "KMS Key ARN for Performance Insights encryption"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Performance Insights data retention in days (7 or 731)"
  type        = number
  default     = 7
}

#------ Protection------
variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

# ----Cloudwatch Alarms ------

variable "create_cloudwatch_alarms" {
  description = "Create CloudWatch alarms for the RDS instance"
  type        = bool
  default     = true
}


variable "enable_cloudwatch_alarms" {
  description = "Whether to create CloudWatch alarms for the primary instance."
  type        = bool
  default     = false
}

variable "alarm_actions" {
  description = "SNS topic ARNs triggered by CloudWatch alarms."
  type        = list(string)
  default     = []
}

variable "cpu_utilization_alarm_threshold" {
  description = "CPU utilization threshold for the CloudWatch alarm."
  type        = number
  default     = 80
}

variable "free_storage_space_alarm_threshold" {
  description = "Free storage space threshold in bytes for the CloudWatch alarm."
  type        = number
  default     = 10737418240
}

variable "freeable_memory_alarm_threshold" {
  description = "Freeable memory threshold in bytes for the CloudWatch alarm."
  type        = number
  default     = 268435456
}

variable "secret_recovery_window_in_days" {
  description = "Secrets Manager recovery window for the generated secret."
  type        = number
  default     = 7
}

variable "kms_key_deletion_window_in_days" {
  description = "Deletion window in days for the KMS key."
  type        = number
  default     = 10
}


