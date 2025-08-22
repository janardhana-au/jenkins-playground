output "named_instance_public_ips" {
  description = "Map of instance names to public IPs"
  value = {
    for i in range(length(var.jenkins_instances)) :
    var.jenkins_instances[i] => aws_instance.jenkins_servers[i].public_ip
  }
}

