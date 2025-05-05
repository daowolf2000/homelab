# Default vars (load from .envrc)
variable "default_password" {
  type      = string
  sensitive = true
}

variable "default_ssh_public_keys" {
  type      = string
  sensitive = true
}
