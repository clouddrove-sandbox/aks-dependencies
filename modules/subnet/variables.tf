variable "subnet_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list[string]
}
