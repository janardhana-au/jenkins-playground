variable "jenkins_instances" {
    type = list(string)
    #default = [ "Jenkins_server","Agent-1"]
    default = [ "Jenkins_server"]
    
  
}
/* variable "allowed_ports" {
    type = list(string)
    default = [ "22", "80" ]
  
} */