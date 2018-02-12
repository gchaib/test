
# Test

Two primary modules are created in the scope of this project. The first one creates an s3 bucket serving a static website while a Cloudfront distribution is responsible for making the website scalable and accessible worldwide. The other create the infrastructure of a docker container service in AWS. It uses Fargate launch type, which provides easiness in deploy docker applications without worrying about hosts infrastructure.

Directory structure (master branch):
```
.
├── backend.tf
├── Dockerfile
├── fargate.tf
├── main.tf
├── modules
│   ├── cloudfront
│   │   ├── cloudfront.tf
│   │   └── vars.tf
│   ├── ecs
│   │   ├── data.tf
│   │   ├── ecs.tf
│   │   ├── output.tf
│   │   ├── templates
│   │   │   ├── fargate-latest.json
│   │   │   └── script.sh.yml
│   │   └── vars.tf
│   ├── network
│   │   ├── network.tf
│   │   ├── output.tf
│   │   └── vars.tf
│   ├── roles
│   │   ├── output.tf
│   │   ├── service_role.tf
│   │   └── task_role.tf
│   └── s3
│       ├── data.tf
│       ├── files
│       │   └── policy.json
│       ├── output.tf
│       ├── s3.tf
│       └── vars.tf
├── provider.tf
├── README.md
├── terraform.tfvars
├── vars.tf
└── www
    └── index.html
```
Little modification was done in dev branch.
### Prerequisites

This project requires the following:

* docker >= 17.12.0-ce
* terraform >= 0.11.3
* awscli >= 1.14.36
* python >= 2.7.13
* AWS account with administrator permissions.

## Getting Started

First steps:

 1. Clone this repository to your local machine.
 2. Install the following: docker, awscli, terraform, and python. Make sure the versions is compatible with the ones describe in the prequisites above.
 3. Configure aws-cli. Since this project uses a remove terraform backend (s3 bucket) to store infrastructure state, this step is necessary.

	```
	$ aws configure

	$ AWS Access Key ID []: Enter your AWS Access Key here!
	$ AWS Secret Access Key []: Enter your Secret Access Key here!
	$ Default region name [us-east-1]: us-east-1
	$ Default output format [json]: json
	```
 4. Configure terraform backend:

	> Warning: It is highly recommended to use s3 backend or other remote backend to store the state of your infrastructure, principally when more than one person is working in the code. However, for the purpose of this project it is up to you decide to do it.

	 1. Without s3 backend:
	1.1 Remove backend.tf and terraform will uses its default backend properties. The state will be stored locally.

	2. With s3 backend:
	2.1 Edit backend.tf:
		```
		terraform {
		  required_version = ">=0.11.3"

		  backend "s3" {
		    bucket = "YOUR BUCKER NAME"
		    key    = "v1/v1.tfstate"
		    region = "us-east-1"
		  }
		}
		```
		2.2 Make sure your credentials has the enough privileges to write the bucket.
 
 5. Configure terraform.tfvars. In this file you will write your aws credentials. Terraform will use them to apply changes in the infrastructure. 
1.1 Create terraform.tfvars in the root directory with the template bellow:
	```
	AWS_ACCESS_KEY= "YOUR AWS ACCESS KEY"
	AWS_SECRET_KEY = "YOUR AWS SECRET KEY"
	AWS_REGION = "YOUR AWS REGION"
	```
 6. Project global variables and descriptions. Change it with your credentials and other aws parameters!
		
	**AWS_ACCESS_KEY**: Aws access key. Do not change it here, it is declared in terraform.tfvars.
	**AWS_SECRET_KEY**: Aws access key. Do not change it here, it is declared in terraform.tfvars.
	**AWS_REGION**: Aws region. You can change it here!
	**subnet_mask_offset**: Subnet mask offset to serve as parameter to cidrsubnet function. Example: For a VPC with cidr block 10.0.0.0/16 the function cidrsubnet(vpc_cidr_block,8,1) will create the string: 10.0.1.0/24.
	**env_id**: AWS account ID.
	**availability_zones**: List of availability zones. Example. us-east-1a, us-east-1b.
	**bucket_name**: Name of s3 bucket.
	**vpc_cidr**: VPC cidr block.

 7. You are all set! 
## (branch) Master vs Dev ##

  1. ####  Master branch is related with first part of the test. Go to next topic (Deployment)!
  2. ####  Dev branch is related with first part of the test. 
	  *  This branch has the following modifications:
		  * Bucket name in vars.tf;
		  * VPC cidr in vars.tf;
		  * ECS module has auto-scaling option;
		  
  
> Warning(1):  These changes destroys some important resources and creates another, therefore it is important to check the resources: DNS, links, etc to correctly test if they are running!

> Warning(2): The dev branch takes a long time to conclude and sometimes occurs timeout while executing terraform apply. If this is the case re-run terraform apply!

> Warning(3): There is a now bug in terraform that results in this output when finishing the execution of the dev branch. The work around (encouraged by terraform's developers) to solve this problem is re-run terraform apply if it happens. Output: 
		
		Error: Error applying plan:

		3 error(s) occurred:

		* module.network.aws_route.public_internet_gateway: 1 error(s) occurred:

		* aws_route.public_internet_gateway: InvalidParameterValue: There is no route defined for '0.0.0.0/0' in the route table. Use CreateRoute instead.
			status code: 400, request id: 01708ed8-a21d-414e-936a-33f544adbb7d
		* module.network.aws_route.private_nat_gateway: 1 error(s) occurred:

		* aws_route.private_nat_gateway: InvalidParameterValue: There is no route defined for '0.0.0.0/0' in the route table. Use CreateRoute instead.
			status code: 400, request id: f0edd9e3-3515-4ba2-92f2-be55dcb6fc6b
		* module.fargate.aws_cloudwatch_metric_alarm.memory_high: aws_cloudwatch_metric_alarm.memory_high: diffs didn't match during apply. This is a bug with Terraform and should be reported as a GitHub Issue.

		Please include the following information in your report:

		    Terraform Version: 0.11.3
		    Resource ID: aws_cloudwatch_metric_alarm.memory_high
		    Mismatch reason: extra attributes: alarm_actions.2664359266, alarm_actions.199958355, ok_actions.4091143226, ok_actions.1760325039
		    Diff One (usually from plan): *terraform.InstanceDiff{mu:sync.Mutex{state:0, sema:0x0}, Attributes:map[string]*terraform.ResourceAttrDiff{"dimensions.ServiceName":*terraform.ResourceAttrDiff{Old:"fargate", New:"fargate-new", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}}, Destroy:false, DestroyDeposed:false, DestroyTainted:false, Meta:map[string]interface {}(nil)}
		    Diff Two (usually from apply): *terraform.InstanceDiff{mu:sync.Mutex{state:0, sema:0x0}, Attributes:map[string]*terraform.ResourceAttrDiff{"dimensions.ServiceName":*terraform.ResourceAttrDiff{Old:"fargate", New:"fargate-new", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "ok_actions.4091143226":*terraform.ResourceAttrDiff{Old:"arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:74e74064-3f71-4a45-9398-902fa08a04d3:resource/ecs/service/fargate/fargate:policyName/scale_down", New:"", NewComputed:false, NewRemoved:true, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "ok_actions.1760325039":*terraform.ResourceAttrDiff{Old:"", New:"arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:67a597c1-6951-4b9f-9202-9147523279d9:resource/ecs/service/fargate/fargate-new:policyName/scale_down", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "alarm_actions.2664359266":*terraform.ResourceAttrDiff{Old:"arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:74e74064-3f71-4a45-9398-902fa08a04d3:resource/ecs/service/fargate/fargate:policyName/scale_up", New:"", NewComputed:false, NewRemoved:true, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}, "alarm_actions.199958355":*terraform.ResourceAttrDiff{Old:"", New:"arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:67a597c1-6951-4b9f-9202-9147523279d9:resource/ecs/service/fargate/fargate-new:policyName/scale_up", NewComputed:false, NewRemoved:false, NewExtra:interface {}(nil), RequiresNew:false, Sensitive:false, Type:0x0}}, Destroy:false, DestroyDeposed:false, DestroyTainted:false, Meta:map[string]interface {}(nil)}

		Also include as much context as you can about your config, state, and the steps you performed to trigger this error.


		Terraform does not automatically rollback in the face of errors.
		Instead, your Terraform state file has been partially updated with
		any resources that successfully completed. Please address the error
		above and apply again to incrementally change your infrastructure.



## Deploying
After completing the initial setup you can start to run the code! **Run the following commands in the order they appear!**

1. `terraform init`
1.1 Sample output:

		Initializing modules...
			- module.fargate
			- module.roles
			- module.network
			- module.cloudfront
			- module.s3

		Initializing the backend...

		Initializing provider plugins...

		The following providers do not have any version constraints in configuration,
		so the latest version was installed.

		To prevent automatic upgrades to new major versions that may contain breaking
		changes, it is recommended to add version = "..." constraints to the
		corresponding provider blocks in configuration, with the constraint strings
		suggested below.

		* provider.aws: version = "~> 1.9"
		* provider.template: version = "~> 1.0"

		Terraform has been successfully initialized!

		You may now begin working with Terraform. Try running "terraform plan" to see
		any changes that are required for your infrastructure. All Terraform commands
		should now work.

		If you ever set or change modules or backend configuration for Terraform,
		rerun this command to reinitialize your working directory. If you forget, other
		commands will detect it and remind you to do so if necessary.
 
2. `terraform plan`
		The command will ask for confirmation after showing the structure modifications it will do. Confirm if it is right!
					Sample Output:
	```
	An execution plan has been generated and is shown below.
	Resource actions are indicated with the following symbols:
	  ~ update in-place
	  - destroy
	-/+ destroy and then create replacement
	 <= read (data resources)

	Terraform will perform the following actions:

	-/+ aws_security_group_rule.alb_to_service_in (new resource required)
	      id:                                                                                                    "sgrule-1197435157" => <computed> (forces new resource)
	      description:                                                                                           "allow all alb traffic to service" => "allow all alb traffic to service"
	      from_port:                                                                                             "0" => "0"
	      protocol:                                                                                              "tcp" => "tcp"
	      security_group_id:                                                                                     "sg-52a4d725" => "${module.fargate.service_sg}" (forces new resource)
	      self:                                                                                                  "false" => "false"
	      source_security_group_id:                                                                              "sg-61afdc16" => "${module.fargate.alb_sg}" (forces new resource)
	      to_port:                                                                                               "65535" => "65535"
	      type:                                                                                                  "ingress" => "ingress"

	-/+ aws_security_group_rule.all_to_alb_in (new resource required)
	      id:                                                                                                    "sgrule-2363938077" => <computed> (forces new resource)
	      cidr_blocks.#:                                                                                         "1" => "1"
	      cidr_blocks.0:                                                                                         "0.0.0.0/0" => "0.0.0.0/0"
	      description:                                                                                           "allow all traffic to alb" => "allow all traffic to alb"
	      from_port:                                                                                             "0" => "0"
	      protocol:                                                                                              "tcp" => "tcp"
	      security_group_id:                                                                                     "sg-61afdc16" => "${module.fargate.alb_sg}" (forces new resource)
	      self:                                                                                                  "false" => "false"
	      source_security_group_id:                                                                              "" => <computed>
	      to_port:                                                                                               "65535" => "65535"
	      type:                                                                                                  "ingress" => "ingress"


	```


3. `terraform apply`
	The command will ask for confirmation after showing the structure modifications it will do. Confirm if it is right!
			Sample Output:
	```
	module.fargate.aws_cloudwatch_metric_alarm.memory_high: Modifying... (ID: memory_alarm)
	  alarm_actions.#:         "0" => "1"
	  alarm_actions.199958355: "" => "arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:67a597c1-6951-4b9f-9202-9147523279d9:resource/ecs/service/fargate/fargate-new:policyName/scale_up"
	  dimensions.ServiceName:  "fargate" => "fargate-new"
	  ok_actions.#:            "0" => "1"
	  ok_actions.1760325039:   "" => "arn:aws:autoscaling:us-east-1:969394324906:scalingPolicy:67a597c1-6951-4b9f-9202-9147523279d9:resource/ecs/service/fargate/fargate-new:policyName/scale_down"
	module.fargate.aws_cloudwatch_metric_alarm.memory_high: Modifications complete after 1s (ID: memory_alarm)
	module.network.aws_route.public_internet_gateway: Creation complete after 1s (ID: r-rtb-c424c1b81080289494)
	module.network.aws_route.private_nat_gateway: Creation complete after 1s (ID: r-rtb-44d732381080289494)
	module.fargate.aws_appautoscaling_target.target: Modifications complete after 2s (ID: service/fargate/fargate-new)

	Apply complete! Resources: 2 added, 2 changed, 0 destroyed.

	```

## Built With

* [Terraform](https://www.terraform.io/) - Write, Plan, and Create Infrastructure as Code


## Authors

* **Giovanni Toledo** - *giovannichaib@gmail.com*

