provider "aws"{
    region = "ap-south-1"
    profile = "saurabh"
}

# Creating Security Groups to allow SSH and HTTP connections
resource "aws_security_group" "allow_connection" {
  name        = "httpconnection"
  description = "Allow SSH and HTTP over inbound traffic"
  vpc_id      = "vpc-d71807bf"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "httpconnection"
  }
}


# Launching the aws instance
resource "aws_instance" "basicOs" {
  depends_on = [
    aws_security_group.allow_connection,
  ]

  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = "basicKey_saurabh"
  security_groups = ["${aws_security_group.allow_connection.name}"]

  tags = {
    Name = "WebServerOS"
  }
}

resource "null_resource" "null2"  {
  
  depends_on = [
    aws_instance.basicOs,
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/Saurabh/Downloads/basicKey_saurabh.pem")
    host        = "${aws_instance.basicOs.public_ip}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd  php git  -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
  
}

# Launching another EBS
resource "aws_ebs_volume" "secondvolume" {
  availability_zone = "ap-south-1a"
  size              = 1
  tags = {
    Name = "VolumeAttach"
  }
}

# Attaching volume to EC2 instance
resource "aws_volume_attachment" "ebs_attach" {
  depends_on = [
    null_resource.null2,
  ]
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.secondvolume.id}"
  instance_id = "${aws_instance.basicOs.id}"
  force_detach = true
}

resource "null_resource" "null1"  {

  depends_on = [
    aws_volume_attachment.ebs_attach,
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Saurabh/Downloads/basicKey_saurabh.pem")
    host     = aws_instance.basicOs.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.ext4  /dev/xvdh",
      "sudo mount  /dev/xvdh  /var/www/html",
      "sudo rm -rf /var/www/html/*",
      "sudo git clone https://github.com/Saurabhdimri06/Terraform /var/www/html/"
    ]
  }
}

resource "aws_s3_bucket" "myprofilebucket12345" {
  bucket = "myprofilebucket12345" 
  acl    = "public-read"
  tags = {
    Name        = "myprofilebucket12345" 
  }
  versioning {
	enabled =true
  }
}

resource "aws_s3_bucket_object" "s3object" {
  bucket = "${aws_s3_bucket.myprofilebucket12345.id}"
  key    = "Profile Image"
  source = "E:/terraform/images/pic1.jpg"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "This is origin access identity"
}

resource "aws_cloudfront_distribution" "imagecf" {

    depends_on = [
    aws_s3_bucket_object.s3object,
  ]

    origin {
        domain_name = "myprofilebucket12345.s3.amazonaws.com"
        origin_id = "S3-myprofilebucket12345"


        s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
       
    enabled = true
      is_ipv6_enabled     = true

    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "S3-myprofilebucket12345"


        # Forward all query strings, cookies and headers
        forwarded_values {
            query_string = false
        
            cookies {
               forward = "none"
            }
        }
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 10
        max_ttl = 30
    }
    # Restricts who is able to access this content
    restrictions {
        geo_restriction {
            # type of restriction, blacklist, whitelist or none
            restriction_type = "none"
        }
    }


    # SSL certificate for the service.
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

output "myos_ip" {
  value = aws_instance.basicOs.public_ip
}