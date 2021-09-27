variable "engine" {
  description = "The mysql engine version"
  type        = string
  default     = "mysql"
}
variable "engine_version" {
  description = "The mysql engine version"
  type        = string
  default     = "8.0.23"
}
variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "root"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 3306
}
variable "allocated_storage" {
  description = "The allocated storage in gigabytes. For read replica, set the same value as master's"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}
variable "subnet_ids" {
  description = "List of subnet id's "
  type        = list(string)
}
variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = "default.mysql5.7"
}
variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}
variable "publicly_accessible" {
  description = "Specifies if the RDS instance is public to outside access"
  type        = bool
  default     = false
}
variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
}
variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'"
  type        = string
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Before and not overlap with maintenance_window"
  type        = string
  default     = ""
}
variable "subnet_group_name" {
  description = "db supnet group name"
  type = string
  default = ""
}
variable "db_tag" {
  type = map(string)
  default = {

  }
}
variable "dbname" {
  type= string
  default = "db"
  
}
variable "name" {
  type = string
  default = ""
}
variable "tags" {
 type = map(string)
 default = {
   
 }
  
}