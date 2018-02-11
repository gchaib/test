resource "aws_iam_role" "ecs_service_role" {
  name = "ecsServiceRole"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
  	"Service": "ecs.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
  }  
 ]
} 
EOF
}

resource "aws_iam_policy" "ecs_service_policy" {
  name = "ecsServicePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service_attach" {
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "${aws_iam_policy.ecs_service_policy.arn}"
}
