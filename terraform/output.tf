output "elb_hostname" {
  value = "${aws_lb.app-lb.dns_name}"
}
