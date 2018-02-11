variable "bucket_name" {}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "error.html"
}

variable "force_destroy_flag" {
  default = "true"
}

variable "versioning_flag" {
  default = "true"
}
