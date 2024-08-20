
# Build the image
Usage:
```bash
docker build --build-arg DB_USERNAME=<DB_USERNAME> --build-arg DB_PASSWORD=<DB_PASSWORD> .
```
Example:
```bash
docker build --build-arg DB_USERNAME=ba-user --build-arg DB_PASSWORD=<DB_PASSWORD> -t db:v0.0.1 . --no-cache
```

# Start the container
Usage:
```bash
docker run -p 5433:5432 <IMAGE_NAME>
```
Example:
```bash
docker run -p 5433:5432 db:v0.0.1
```