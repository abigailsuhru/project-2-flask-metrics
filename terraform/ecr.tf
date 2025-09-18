resource "aws_ecr_repository" "app" {
  name = "${var.project_name}-app"

  lifecycle {
    prevent_destroy = true
  }
  
  image_scanning_configuration {
     scan_on_push = true
  }

}
