output "lb_dns_name" {
  value = module.vpc.lb_dns_name
}

output "your_bastion_host_ip" {
  value = module.server.bastion-ip
}

output "wordpress_ips" {
  value = module.server.private-ip[*]
}

resource "local_file" "ssh_config" {
  content = templatefile ( "config.tmpl",
    {
       count = length(module.server.private-ip),
       bastion_hostname = module.server.bastion-ip,
       private-ip = module.server.private-ip[*]
       
    })

    filename = "config"
  
}



resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", 
  {
    bastion-dns = module.server.bastion-dns,
    bastion-ip = module.server.bastion-ip,
    bastion-id = module.server.bastion-id,
    private-dns = module.server.private-dns,
    private-ip = module.server.private-ip,
    private-id = module.server.private-id
  })
  filename = "ansible/inventory"
}

resource "local_file" "group_vars" {
  content = templatefile("all.tmpl",
{
  
    
    mysql_root_password =  module.database.rds_admin_password
    mysql_root_user =  module.database.rds_admin_username
    mysql_login_host = module.database.rds_hostname 
    // mysql_user_host: '' # your web server private ip


})
filename = "ansible/group_vars/all"
} 

