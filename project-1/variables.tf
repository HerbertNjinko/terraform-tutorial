#Creating an input variable
variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "azs" {
  type = list(string)
  default = [ "us-west-1b", "us-west-1c" ]
}

