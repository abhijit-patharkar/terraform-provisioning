resource "aws_security_group" "web" {
  name        = "webserver"
  description = "Public HTTP + SSH"
  vpc_id      = aws_vpc.LF-VPC.id


  ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = [
         "0.0.0.0/0"]
   }


   ingress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
      self = true
    }

    ingress {
       from_port = 8080
       to_port = 8080
       protocol = "tcp"
       cidr_blocks = [
         "0.0.0.0/0"]
     }

     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
          "0.0.0.0/0"]
      }
    egress {
        # allow all traffic to private SN
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }
}
