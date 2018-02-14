Begin with:

`git clone https://github.com/Juniper/contrail-dev-env`

`cd contrail-dev-env`

Make sure that your docker engine supports images bigger than 10GB. For instructions,
see here: https://stackoverflow.com/questions/37100065/resize-disk-usage-of-a-docker-container

Execute this script to start up all the required containers:
`./startup.sh`

Now, 3 containers are started:
* contrail-developer sandbox
* registry container
* httpd container

Connect to the developer-sandbox container with:

`docker attach contrail-developer-sandbox`

Inside, you can use the standard `scons` commands, and if you want to build rpms or containers,
execute: 

`cd contrail-dev-env`

`make rpm`

`make containers`
