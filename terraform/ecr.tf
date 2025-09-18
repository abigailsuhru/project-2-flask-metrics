resource "aws_ecr_repository" "app" {
  name = "devops-project-2-app"

  lifecycle {
    prevent_destroy = true
  }

  name                 = "${var.project_name}-app"
  image_scanning_configuration { scan_on_push = true }
  image_tag_mutability = "MUTABLE"

}
