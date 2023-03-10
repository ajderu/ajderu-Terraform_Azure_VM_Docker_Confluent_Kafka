variable "location" {
  type    = string
  default = "westeurope"
}
variable "prefix" {
  type    = string
  default = "dev-kafka"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}