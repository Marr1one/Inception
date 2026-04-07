# USER DOCUMENTATION

## 🔹 Overview

This project provides a complete web infrastructure using Docker, composed of:

* **NGINX**: Handles HTTPS requests and acts as the entry point.
* **WordPress**: Hosts the website.
* **MariaDB**: Stores the website data.

---

## 🔹 Starting and Stopping the Project

### Start the project:

```bash
make
```

### Stop the project:

```bash
make down
```

### Rebuild the project:

```bash
make re
```

---

## 🔹 Accessing the Website

Once the project is running, open a browser and go to:

```
https://<your_domain>
```

Example:

```
https://maissat.42.fr
```

---

## 🔹 Accessing the Admin Panel

Go to:

```
https://<your_domain>/wp-admin
```

Log in using the administrator credentials defined in the `.env` file.

---

## 🔹 Credentials Management

All credentials (database, WordPress users) are stored in the `.env` file at the root of the project.

Example:

```
MYSQL_DATABASE=
MYSQL_USER=
MYSQL_PASSWORD=
WP_ADMIN_USER=
WP_ADMIN_PASSWORD=
```

---

## 🔹 Checking Services

### Check running containers:

```bash
docker ps
```

### Check logs:

```bash
docker logs <container_name>
```

### Access a container:

```bash
docker exec -it <container_name> bash
```

---

## 🔹 Data Persistence

All data is stored using Docker volumes:

* Database: `/var/lib/mysql`
* Website files: `/var/www`

These ensure that data is not lost when containers are stopped or removed.
