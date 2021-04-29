# Simply usage

Provide your AWS credentials:


`` export AWS_ACCESS_KEY_ID = "" ``        
`` export AWS_SECRET_ACCESS_KEY = "" ``
 
Then clone current repository and
 
``terraform init  ``  
``terraform apply ``  

Take link to load balancer and then enter   

`` cd ansible/ && ansible-playbook wordpress.yml -i inventory ``  
