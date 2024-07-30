vpc_cidr_block    = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"


secgrps = {

    "ec2_01" = {
        egress = [{
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
            security_groups = null
            description = "allow outbound traffic"
        }]

        ingress = [
            {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                security_groups = null
                description = "allow SSH connection"       
            },

            {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                security_groups = null
                description = "allow 80 port"
            }
        ]
    }

}