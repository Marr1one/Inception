# DEVELOPER DOCUMENTATION

## 🔹 Environment Setup

### Prerequisites

* Docker
* Docker Compose
* Make

---

## 🔹 Project Configuration

All configuration is done through:

* `.env` file (credentials and variables)
* `docker-compose.yml`
* Configuration files inside `srcs/`

---

## 🔹 Build and Launch

### Build and start:

```bash
make
```

### Stop:

```bash
make down
```

### Rebuild:

```bash
make re
```

---

## 🔹 Managing Containers

### List containers:

```bash
docker ps
```

### View logs:

```bash
docker logs <container_name>
```

### Access container:

```bash
docker exec -it <container_name> bash
```

---

## 🔹 Managing Volumes

### List volumes:

```bash
docker volume ls
```

### Inspect a volume:

```bash
docker volume inspect <volume_name>
```

---

## 🔹 Data Storage and Persistence

The project uses two main Docker volumes:

* **MariaDB volume** (`/var/lib/mysql`):  
  Stores all database data (tables, users, content).

* **WordPress volume** (`/var/www`):  
  Stores website files (WordPress core, themes, plugins).

These volumes are managed by Docker.  

However, data will be permanently deleted only if both the Docker volumes and the host data directory are removed (e.g., using `
docker-compose down -v` and manual deletion of `/home/login/data`).

## 🔹 Architecture Overview

* NGINX handles HTTPS and forwards requests to WordPress.
* WordPress communicates with MariaDB.
* All services are connected through a Docker network.

---

## 🔹 Notes

* Containers follow best practices by running a single main process (PID 1).
* Services are isolated but communicate through a Docker bridge network.
* Data is persistent thanks to Docker volumes.
