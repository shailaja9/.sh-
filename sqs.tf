/************* SQS:sqs-for-prod.fifo ******************/
resource "aws_sqs_queue" "queue1" {
  name = "${var.project.name}-${terraform.workspace}-${var.sqs.queue1}"
}
