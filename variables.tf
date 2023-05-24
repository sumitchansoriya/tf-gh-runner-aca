variable "location" {
  type        = string
  description = <<-EOF
    (Optional) The Azure location to create the resources

    [Default: useast1]
  EOF
  default     = "eastus"
}

variable "environment" {
  type        = string
  description = <<-EOF
        (Optional) The environment where the resources will be created, as an acronym.
        Possible values:
            - "sbx"
            - "dev"
            - "tst"
            - "stg"
            - "prd"

    [Default: dev]
  EOF
  default     = "dev"

  validation {
    condition     = can(regex("sbx|dev|tst|stg|prd", var.environment))
    error_message = "This must be an acronym of the environment."
  }
}

variable "org" {
  type        = string
  description = "(Required) The Org / Department / Group name"
}

variable "project" {
  type        = string
  description = "(Required) The project name"
}
