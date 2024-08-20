
# Run with Docker

## Build the Docker image
Usage:
```bash
docker build -t <IMAGE_NAME> .
```
Example:
```bash
docker build -t analytics-api:v0.0.1 . --no-cache
```

## Run the Docker container
Usage:
```bash
docker run -e DB_USERNAME=<DB_USERNAME> -e DB_PASSWORD=<DB_PASSWORD> <IMAGE_NAME>
```
Example:
```bash
docker run -p 5153:5153 -e DB_USERNAME=ba-user -e DB_PASSWORD=<DB_PASSWORD> -e DB_HOST=host.docker.internal -e DB_PORT=5433 -e DB_NAME=coworking-space-db analytics-api:v0.0.1
```

## Verify the application is running properly
You can check the API is receiving requests successfully by making a call to the `/health_check` endpoint.

Example `curl` command:
```bash
curl http://127.0.0.1:5153/health_check
```
```
ok
```