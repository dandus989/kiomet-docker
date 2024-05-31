# Docker Image for Kiomet
This Dockerfile builds a Docker image for [Kiomet](https://github.com/SoftbearStudios/kiomet), an online multiplayer real-time strategy game by Softbear Inc .

# Usage

## Prerequisites
Before using this Dockerfile, ensure that you have Docker installed on your system. You can download and install Docker from the official [Docker website](https://www.docker.com/).

## Building the Docker Image
To build the Docker image for Kiomet, follow these steps:

- Clone this repository to your local machine:

        git clone https://github.com/dandus989/kiomet-docker.git

- Navigate to the cloned directory:

        cd kiomet-docker

- Build the Docker image using the provided Dockerfile:

        docker build -t kiomet-docker .

- Running the Docker Container

    Once the Docker image is built, you can run a Docker container using the following command:

        docker run -d kiomet-docker
  
    Replace kiomet-docker with the name you specified when building the Docker image if you used a different name.

- Accessing Kiomet

    After running the Docker container, you can access Kiomet by opening a web browser and navigating to http://localhost or https://localhost.

# License
This Dockerfile and associated configurations are licensed under the GNU Lesser General Public License v3.0. See the LICENSE file for more details.

# Acknowledgments
We would like to express our gratitude to SoftbearStudios for developing Kiomet, a powerful software solution that [brief acknowledgment of Kiomet's significance and impact].
