# GWX Registry API

Gameworks Registry is one the main module of Gameworks Service Stack. It holds the most of the data in Gameworks Ecosystem, like Users, Players, Publishers, Games, etc.


## Getting Started

This section will give you instructions on how to get started on running this project on your local machine. This project uses Ruby v2.5.7 and Rails 5.2.2. Below you can find more detailed instructions on how get up and running.

### Prerequisites

- ruby v 2.5.7
- Image Magick (for processing uploads)


### Running locally
Start by cloning this repository.
```
$ git clone git@github.com:gameworks-gwx/gwx-registry-api.git && cd gwx-registry-api
```
Install gem dependencies by running
```
$ bundle install
```
Setup the local environment db
```
$ rails db:setup
```
Try to run the server and see if everything is okay
```
$ rails server
```

## Tests
### Structure
Specs are found in the root directory in the folder named `spec`
```
   /spec
     - /factories ** This folder contains the fixtures for the databases
     - /models ** Unit model specs
     - /requests ** API specs
     - /services ** Unit service specs
     - /support ** Spec Helpers,Utils etc
```
### Running the tests
For running the test you can simply type the command
```
$ bundle exec rspec
```
As a result you will see something like this
```
Finished in 25.91 seconds (files took 4.98 seconds to load)
206 examples, 0 failures, 1 pending
```

## API Documentation
As for the API Documentation, we have put up a [Postman](https://stackedit.io/app#) collection for this. You may export the postman files `postman_collection.json` and `postman_environment.json` found in the root project directory. 

## Deployment
We use `capistrano` gem to ease out deployment in both staging and production. See [here]([https://github.com/capistrano/capistrano](https://github.com/capistrano/capistrano)) for more details.

###  Setup
We deploy this project in an AWS EC2 Instance on an Ubuntu 18.04 distro. As for the setup instructions, see our detailed dedicated [wiki](https://github.com/gameworks-gwx/gwx-registry-api/wiki/AWS-Cloudformation-Stack).

## Continuous Integration
As part of the deployment, we have integrated CircleCI for our CI/CD Pipeline. See the config file for the CircleCI found in `.circleci/config.yml`

## Built with
- Ruby 2.5.7
- Rails 5.2.2

