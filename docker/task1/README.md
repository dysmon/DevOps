
# Old Opera Browser in Docker

This project demonstrates how to install and run the old version of the Opera browser (11.50) in a Docker container based on Ubuntu 16.04.

### Prerequisites

Before running the container, ensure you have the following prerequisites:

1. **X11 Permissions**: Allow the Docker container to connect to the X server by running:
   ```bash
   xhost +local:docker
   ```

2. **Docker Installed**: Ensure you have Docker installed on your system.

## Notes

- This setup is specifically for running an old version of Opera (11.50) and may not be suitable for general web browsing due to security vulnerabilities in outdated software.
- Ensure to check the compatibility of other dependencies if you plan to run this in a production-like environment.

## Dockerfile

The provided `Dockerfile` sets up the environment for running Opera:

```dockerfile
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libsm6 \
    libfreetype6 \
    libfontconfig1 \
    --no-install-recommends

ARG OPERA_VERSION=11.50
# Set the download URL for Opera
RUN wget --no-check-certificate -O /tmp/opera.tar.gz "https://get.opera.com/pub/opera/linux/1150/opera-${OPERA_VERSION}-1074.x86_64.linux.tar.gz" \
    && tar -xzf /tmp/opera.tar.gz -C /opt/ \
    && ln -fs /opt/opera/opera /usr/bin/opera \
    && rm /tmp/opera.tar.gz \
    && echo -e "\n\n" | /opt/opera*/install

ENTRYPOINT ["/usr/local/bin/opera", "https://www.armorgames.com"]
```

## Running the Docker Container

To run the Opera browser in the Docker container, use the following command:

```bash
docker run -it --rm -e DISPLAY=$DISPLAY --network host old_opera
```


