# Test

Two primary modules are created in the scope of this project. The first one creates an s3 bucket serving a static website while a cloudfront distribution is reponsible for making the website scalable and accessible worldwide. The other create the infrastructure of a docker container service in AWS. It uses fargate launch type, which provides easiness in deploy docker applications without worrying about hosts infrastructure.

### Prerequisites

This project requires the following:

* docker >= 17.12.0-ce
* terraform >= 0.11.3
* awscli >= 1.14.36
* python >= 2.7.13
* AWS account.

## Getting Started

First steps:

- Clone this repository to your local machine.
- Install the following: docker, awscli, terraform, and python. Make sure the versions is compatible with the ones describe in the prequisites above.
- Configure aws-cli. Since this project uses a remove terrafor backend (s3) to store infrastructure state, this step is necessary.

```
aws configure

AWS Access Key ID []: Enter your AWS Access Key here!
AWS Secret Access Key []: Enter your Secret Access Key here!
Default region name [us-east-1]: us-east-1
Default output format [json]: json

```
- Configure s3 backend
** if
- Configure terraform.tfvars. In this file you will write your aws credentials

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
