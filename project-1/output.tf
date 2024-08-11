#creating output variable

output "public_ip" {
  value = [aws_instance.app_server[*]]
}

/*output "launch_template_name" {
  value = "My_asgServer"
}

output "aws_lb_listener" {
  value = aws_lb.app_server.arn
}

output "aws_autoscaling_attachment" {
  value       = aws_autoscaling_group.app_server.id
}

output "aws_cloudwatch_metric_alarm" {
  value = aws_autoscaling_group.app_server.name
}*/