/******************* ECR: integration ****************/
resource "aws_ecr_repository" "integration-repo" {
  name = "${var.project.name}-${terraform.workspace}-integration"
  tags = var.default_tags
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "integration-repo-policy" {
  repository = aws_ecr_repository.integration-repo.name
  policy     = templatefile("${path.module}/data/ecr-repository-policy.tpl", {})
}

/******************* ECR: config ****************/
resource "aws_ecr_repository" "config-repo" {
  name = "${var.project.name}-${terraform.workspace}-config"
  tags = var.default_tags
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "config-repo-policy" {
  repository = aws_ecr_repository.config-repo.name
  policy     = templatefile("${path.module}/data/ecr-repository-policy.tpl", {})
}

/******************* ECR: logging ****************/
resource "aws_ecr_repository" "logging-repo" {
  name = "${var.project.name}-${terraform.workspace}-logging"
  tags = var.default_tags
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "logging-repo-policy" {
  repository = aws_ecr_repository.logging-repo.name
  policy     = templatefile("${path.module}/data/ecr-repository-policy.tpl", {})
}

/******************* ECR: s2s ****************/
resource "aws_ecr_repository" "s2s-repo" {
  name = "${var.project.name}-${terraform.workspace}-s2s"
  tags = var.default_tags
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "s2s-repo-policy" {
  repository = aws_ecr_repository.s2s-repo.name
  policy     = templatefile("${path.module}/data/ecr-repository-policy.tpl", {})
}
