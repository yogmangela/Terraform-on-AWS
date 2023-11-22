
# Security Groups
resource "aws_security_group" "nfs" {
  name_prefix = "${var.namespace}-nfs-"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow any NFS traffic from private subnets"
    cidr_blocks = concat(values(aws_subnet.private)[*].cidr_block, values(aws_subnet.private_ingress)[*].cidr_block)
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }

  egress {
    description      = "Allow all outbound traffic"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}

resource "aws_security_group" "app" {
  name_prefix = "${var.namespace}-app-"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow HTTPS from any IP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP from any IP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    description      = "Allow all outbound traffic"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}

resource "aws_security_group" "db" {
  name_prefix = "${var.namespace}-db-"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow incoming traffic for MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(values(aws_subnet.private)[*].cidr_block, values(aws_subnet.private_ingress)[*].cidr_block)
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "any" {
  name_prefix = "${var.namespace}-any-"
  vpc_id      = aws_vpc.default.id

  ingress {
    description      = "Allow any incoming traffic "
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
