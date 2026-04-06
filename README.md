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

The infrastructure includes the following services, each in its own container:

| Service | Description |
|---	  |             |
| **NGINX** | Reverse proxy and TLS termination (TLSv1.2/1.3 only) — the sole entry point |
| **WordPress** | PHP-FPM-based CMS(Content Management System) connected to MariaDB |
| **MariaDB** | Relational database storing WordPress data |

All services communicate through a custom Docker network and persist data via Docker volumes.

### Docker & Sources

The project uses **Docker** and **Docker Compose** to define, build, and run the infrastructure. All images are built from custom `Dockerfile`s — no pre-built images from Docker Hub (except base OS image `debian`).

Sensitive data (database passwords, WordPress admin credentials) are managed through **Docker Secrets**, not plain environment variables. Configuration files and initialization scripts are included in the `srcs/` directory alongside the `docker-compose.yml`. // AAAAAAAAAAAAAAAAAAAAAAAAAAA FAUT QUE JE REVIENNE LA DESSUS AAAAAAAAAA UN .ENV SUFFIT IMO QQQQQQQQQQAAAAAAa

**Main design choices:**

- NGINX is the only container exposed to the outside world (port 443, HTTPS only).
- WordPress communicates with MariaDB via the internal Docker network, never exposed publicly.
- Volumes are used for database persistence and WordPress files, mapped to `/home/<login>/data/` on the host.
- All containers are set to restart automatically on failure.

---

### Virtual Machines vs Docker

| | Virtual Machines | Docker |
|---|---|---|
| **Isolation** | Full OS-level isolation via hypervisor | Process-level isolation via Linux namespaces & cgroups | A REFAIRE EN UNE OU DEUX PHRASE PLUS SIMPLES 
| **Weight** | Heavy: each VM includes a full OS kernel | Lightweight: containers share the host kernel |
| **Startup time** | Minutes | Seconds |
| **Portability** | Limited — tied to hypervisor compatibility | Highly portable — runs anywhere Docker is installed |
| **Use case** | Full system emulation, strong security boundaries | Microservices, CI/CD, reproducible dev environments |

Docker is preferred here because we want lightweight, reproducible, and quickly deployable services without the overhead of full virtual machines.

---

### Secrets vs Environment Variables

| | Secrets | Environment Variables | A REFAIRE EN UNE OU DEUX PHRASE PLUS SIMPLES 
|---|---|---|
| **Security** | Stored as files in `/run/secrets/`, not exposed in `docker inspect` or process lists | Visible in `docker inspect`, logs, and child processes |
| **Persistence** | Managed by Docker, never written to the image layer | Can accidentally leak into image layers via `ENV` instructions |
| **Use case** | Passwords, API keys, certificates | Non-sensitive config (ports, hostnames, feature flags) |

In this project, credentials (DB password, WordPress admin password, etc.) are handled as **Docker Secrets** to avoid exposing sensitive data in environment variables or image metadata.

---

### Docker Network vs Host Network

| | Docker Network (bridge) | Host Network | A REFAIRE EN UNE OU DEUX PHRASE PLUS SIMPLES 
|---|---|---|
| **Isolation** | Containers have their own virtual network, isolated from the host | Containers share the host's network stack directly |
| **Security** | Better isolation — containers only communicate through defined rules | No network isolation — full access to host interfaces |
| **Port management** | Explicit port mapping required (`-p 443:443`) | No port mapping needed, but risk of conflicts |
| **Use case** | Multi-service apps where services communicate internally | Performance-critical apps needing raw network speed |

This project uses a **custom bridge network** so that services (NGINX, WordPress, MariaDB) can communicate by container name (DNS resolution) while remaining isolated from the host and each other unless explicitly configured.

---

### Docker Volumes vs Bind Mounts

| | Docker Volumes | Bind Mounts | A REFAIRE EN UNE OU DEUX PHRASE PLUS SIMPLES 
|---|---|---|
| **Management** | Fully managed by Docker | Directly mapped to a host path |
| **Portability** | Portable — not tied to a specific host path | Tied to the host filesystem structure |
| **Performance** | Optimized for Docker I/O | Depends on host OS and filesystem |
| **Visibility** | Stored in Docker's internal directory | Directly visible and editable from the host |
| **Use case** | Persistent data in production | Development — live editing, config injection |

This project uses **named volumes** mapped to specific host paths (`/home/<login>/data/`) as required by the subject, combining the benefits of visibility (for evaluation) with Docker-managed lifecycle.

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- A Linux system (or VM) — macOS may require path adjustments
- `make` utility

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/<login>/inception.git //mettre le lien 42 
   cd inception
   ```

2. Add the domain to your `/etc/hosts`:
   ```bash
   echo "127.0.0.1  <login>.42.fr" | sudo tee -a /etc/hosts
   ```

3. Create the required data directories:
   ```bash
   mkdir -p ~/data/wordpress ~/data/mariadb
   ```

4. Fill in your secrets in `srcs/secrets/` (see `srcs/secrets/README` for required files). // moi je met dans .env

### Build & Run

```bash
make        # Build and start all containers
make down   # Stop and remove containers
make clean  # Stop containers and remove volumes
make re     # Full rebuild
```

### Access

Once running, open your browser and navigate to:

```
https://maissat.42.fr
```

> ⚠️ The certificate is self-signed — you will need to accept the browser warning.

---

## Resources

### Documentation

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [TLS/SSL with NGINX](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)

### Articles & Tutorials

- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Understanding Docker networking](https://docs.docker.com/network/)
- [Difference between COPY and ADD in Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy)
- [Managing sensitive data with Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)
- [Linux namespaces and cgroups — the foundation of containers](https://www.redhat.com/en/topics/containers/whats-a-linux-container)

### AI Usage

AI (Claude, Anthropic) was used during this project for the following tasks:

- **Debugging**: Help diagnosing issues with entrypoint scripts, service startup ordering, and volume permission errors.
- **Documentation**: Generating and structuring this README, particularly the comparison tables.
- **Configuration review**: Reviewing NGINX TLS configuration and PHP-FPM pool settings for correctness.
- **Understanding concepts**: Clarifying the differences between Docker networking modes, secrets vs environment variables, and volume types.

AI was **not** used to write the core Dockerfiles, `docker-compose.yml`, or service configuration files — those were written and tested manually to ensure full understanding of each component.