# OpcUaMachineTools
Examples, small programs and how-tos regarding OPC UA on machine tools.

### Server examples
* [Python machine demo server](/MachineDemoServer/Python)
* [Python alarms and conditions to data items converter](/AlarmConverter/Python)

### Client examples
* [Python examples](/Examples/Python)
* [NetCore examples](/Examples/NetCore)
* [NodeRed examples](/Examples/NodeRed)

### Run the machine demo server with Docker

With Docker Desktop running Linux containers, run these commands from the repository root:

```sh
docker build -t opcua-machine-tools:local .
docker run --rm --name opcua-machine-tools -p 50000:50000 opcua-machine-tools:local
```

Connect an OPC UA client to `opc.tcp://localhost:50000` (use the Docker host's IP address for remote clients). Stop the server with Ctrl+C.

The image runs the Python machine demo server and includes its sample recordings and demo certificates. During the build, its endpoint is configured to listen on `0.0.0.0` inside the container so the published port is reachable. Default playback settings are defined in `MachineDemoServer/Python/ReplayConfiguration.xml`. Changes to files included in the image require a rebuild, but playback speed can be overridden at container startup as shown below.

#### Select playback speed

Set `PLAY_SPEED_FACTOR` with Docker's `-e` option to override the XML's `playSpeedFactor`. For example, to replay at 100 times the recorded speed:

```sh
docker run --rm --name opcua-machine-tools -p 50000:50000 -e PLAY_SPEED_FACTOR=100 opcua-machine-tools:local
```

Use `1` for the original recorded speed, `0.5` for half speed, or `20` for 20 times the recorded speed. Without `PLAY_SPEED_FACTOR`, the server uses the XML value (currently `20`). The value must be a finite number greater than zero; invalid values stop startup.

The factor divides the recorded time between entries; it does not change the fixed two-second pause between recording loops. The effective factor is printed at startup.

After pulling this feature for the first time, rebuild the image using `docker build -t opcua-machine-tools:local .`. For subsequent speed changes, stop the existing container and recreate it with the desired `-e PLAY_SPEED_FACTOR=...` value; no image rebuild is needed. With `--rm`, stopping the container removes it and frees its name. Simply restarting an existing container does not change its environment variables.

#### Run in the background and manage the container

To run the OPC UA server in the background (detached mode), add `-d`. The command returns to your terminal immediately; the server keeps running:

```sh
docker run -d --name opcua-machine-tools -p 50000:50000 -e PLAY_SPEED_FACTOR=100 opcua-machine-tools:local
```

This example intentionally omits `--rm` so a stopped container can be started again or restarted. Build the image first as shown above. Useful commands:

```sh
# List running containers
docker ps

# List running and stopped containers
docker ps -a

# Follow logs (Ctrl+C stops following logs, not the container)
docker logs -f opcua-machine-tools

# Show recent logs without following them
docker logs --tail 100 opcua-machine-tools

# Stop, start, or restart the same container
docker stop opcua-machine-tools
docker start opcua-machine-tools
docker restart opcua-machine-tools

# Remove a stopped container
docker rm opcua-machine-tools
```

To **change the playback speed**, recreate the container with a new environment variable (a simple `docker restart` keeps the old value):

```sh
docker stop opcua-machine-tools
docker rm opcua-machine-tools
docker run -d --name opcua-machine-tools -p 50000:50000 -e PLAY_SPEED_FACTOR=20 opcua-machine-tools:local
```

`docker stop` and `docker rm` are separate commands here because the detached container is not using `--rm`. If you started the earlier foreground example with `--rm`, stopping it automatically removes it.

### How-tos
* [How to connect to different machines via the OPC UA Gateway](/Doc/opcuagateway.md)
* [How to determine the connection state of a machine aggregated in the OPC UA gateway](/Doc/connectionstate.md)
* [How to add orders to the production plan of the machine](/Doc/productionplan.md)

### Guidelines and best practices
* [General guidelines and remarks](/Doc/guidelines.md)
* [Recommendations for usage of OPC UA clients](/Doc/opcuaclients.md)
* [Signal recommendations for different use cases](/Doc/signalsusecases.md)
