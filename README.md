# GOB-Template

Provides a bash script that initialises a default GOB repo with message bus and API
connectivity. Also initialises a basic Openstack deploy file if an example file is
present (this file is not checked in the repo, but is available within the team).

## Usage:

```shell script
./create.sh
```

Example output:

```shell script
This script creates a new GOB service with basis repo and configuration
What is the name of the new service?
message
The repo name will be GOB-Message and the Docker container name will be gobmessage. Is this ok? (press Y to confirm)
Y
Copy template files to output directory
Rename python module
Replace variables in templates
Done.
Your new repo is in ./out/GOB-Message
The Openstack deploy config is ./out/deploy-gob-message.yml

```

## Openstack config
The Openstack config template file should be placed under ```./template/openstack-template.yml``` for this script
to create a default config. If no template is found, this step is skipped and a message is shown to notify the user.