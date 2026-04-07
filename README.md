*This project has been created as part of the 42 curriculum by maissat.*

---

# Inception

> A system administration project using Docker to build and manage a small infrastructure of services.

---

## Description

**Inception** is a project whose goal is to set up a complete web infrastructure using **Docker**. Each service runs in its own dedicated container, built from scratch using custom Dockerfiles.

### Goal

The project aims to deepen understanding of containerization, system administration, and the orchestration of multiple services in an isolated and reproducible environment.

### Overview of Services

The infrastructure is composed of three main services, each running in its own container:

| Service       | Description                                                                                |
| ------------- | ------------------------------------------------------------------------------------------ |
| **NGINX**     | Handles incoming requests, manages HTTPS (TLS), and acts as the entry point to the website |
| **WordPress** | The website application, running with PHP-FPM and connected to the database                |
| **MariaDB**   | Stores all the website data, such as users, posts, and settings                            |


All services communicate through a custom Docker network and persist data via Docker volumes.

### Docker & Sources

The project uses **Docker** and **Docker Compose** to define, build, and run the infrastructure. All images are built from custom `Dockerfile`s — no pre-built images from Docker Hub (except base OS image `debian`).

Sensitive data (such as database passwords and WordPress admin credentials) are managed using a `.env` file, which i prefer for his simplicity. Configuration files and initialization scripts are stored in the `srcs/` directory alongside the `docker-compose.yml`.

**Main design choices:**

- NGINX is the only container exposed to the outside world (port 443, HTTPS only).
- WordPress communicates with MariaDB via the internal Docker network, never exposed publicly.
- Volumes are used for database persistence and WordPress files, mapped to `/home/<login>/data/` on the host.
- All containers are set to restart automatically on failure.

---

### Virtual Machines vs Docker

* **Virtual Machines** run a full operating system with their own kernel, making them heavier but strongly isolated.
* **Docker** runs applications in lightweight containers that share the host kernel, making them faster and more efficient.

---

### Secrets vs Environment Variables

* **Secrets** securely store sensitive data like passwords or API keys without exposing them.
* **Environment variables** are used for general configuration and may be visible.

---

### Docker Network vs Host Network

* A **Docker bridge network** isolates containers and allows controlled communication between them.
* The **host network** gives containers direct access to the host’s network, but without isolation.

---

### Docker Volumes vs Bind Mounts

* **Docker volumes** are managed by Docker and provide portable and persistent data storage.
* **Bind mounts** directly map a host directory into a container, which is useful for development but less portable.

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- A Linux system (or VM) — macOS may require path adjustments
- `make` utility

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com//inception.git //mettre le lien 42 
   cd inception
   ```

2. Add the domain to your `/etc/hosts` if he is not in it:
   ```bash
   echo "127.0.0.1  <login>.42.fr" | sudo tee -a /etc/hosts
   ```

3. Remember to implement your own .env file in the `srcs/` folder with your passwords and usernames (dont forget the domain name) . // moi je met dans .env

### Build & Run

```bash
make        # Build and start all containers
make down   # Stop and remove containers
make clean # Stop and clean more than make down
make fclean  # Stop containers and remove volumes
make re     # Full rebuild
```

### Access

Once running, open your browser and navigate to:

```
https://<your-login42>>.fr
```

You can also write articles with this link and in possession of your admin password and username:

```
https://<your-login42>>.fr/wp-admin
```

> ⚠️ The certificate is self-signed — you will need to accept the browser warning.

---

## Resources

### Documentation

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [MariaDB documentation](https://mariadb.com/kb/en/)

### AI Usage

AI (Chatgpt and Google Gemini) was used during this project for the following tasks:

- **Debugging**: Help diagnosing issues with entrypoint scripts, service startup ordering, and volume permission errors.
- **Documentation**: Generating and structuring this README, particularly the comparison tables and for the facilitation of documentation.
- **Understanding concepts**: Clarifying the differences between Docker networking modes, secrets vs environment variables, and volume types.
