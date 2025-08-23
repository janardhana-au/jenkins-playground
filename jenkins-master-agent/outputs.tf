output "jenkins_server_public_ips" {
  description = "Map of instance names to public IPs"
  value = {
    for i in range(length(var.jenkins_server)) :
    var.jenkins_server[i] => aws_instance.jenkins_servers[i].public_ip
  }
}

output "jenkins_agent_public_ips" {
  description = "Map of instance names to public IPs"
  value = {
    for i in range(length(var.jenkins_agent)) :
    var.jenkins_agent[i] => aws_instance.jenkins_agent[i].public_ip
  }
}

