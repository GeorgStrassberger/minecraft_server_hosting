# Minecraft Server Hosting via Docker (Java Edition)

This project provides a complete Minecraft Java Edition server setup using Docker – without relying on prebuilt images. It uses the official server.jar from Mojang, referenced via its SHA1 hash.

---

## Table of Contents

- [Minecraft Server Hosting via Docker (Java Edition)](#minecraft-server-hosting-via-docker-java-edition)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Quickstart](#quickstart)
  - [Mojang-Hash SHA1 for server.jar](#mojang-hash-sha1-for-serverjar)
  - [Environment Variables](#environment-variables)
  - [Projectstruktur](#projectstruktur)
  - [Testing](#testing)

## Overview

- `Dockerfile` – Builds the server image from an OpenJDK base
- `docker-compose.yml` – Orchestrates the container with volumes, ports & build args
- `.env` – Manages server configuration through environment variables

---

## Prerequisites

- A Linux VM or server (e.g., Hetzner cloud VM)
- Docker and Docker Compose installed
- Port 8888 must be open to the internet

---

## Quickstart

1. Clone the repository:

   ```bash
   git clone https://github.com/dein-benutzername/minecraft-server-docker.git
   cd minecraft-server-docker
   ```

2. Create a `.env` file:
   ```bash
   cp .env.example .env
   ```
3. Add the correct SHA1 for the `server.jar` (see below)
4. Build and Start the server:
   ```bash
   docker compose up -d --build
   ```
5. Connect in your Minecraft client:
   ```bash
   <your-ip>:8888
   ```

---

## Mojang-Hash SHA1 for server.jar

1. Open Mojang’s official version manifest:

```text
https://launchermeta.mojang.com/mc/game/version_manifest.json
```

Das ist eine JSON-Datei mit allen offiziellen Versionen.

2. Find your version (e.g. 1.21.8) in the list:
   Suche nach:

```json
"id": "1.21.8"
```

3. Copy the associated url, for example:

```json
"url": "https://piston-meta.mojang.com/v1/packages/24b08e167c6611f7ad895ae1e8b5258f819184aa/1.21.8.json"
```

4. Open that URL and look for:

```json
"server": {
  "sha1": "6bce4ef400e4efaa63a13d5e6f6b500be969ef81",
  "url": "https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar"
}
```

5. Copy the sha1 value and paste it into your `.env`:

```bash
SHA1=6bce4ef400e4efaa63a13d5e6f6b500be969ef81
```

---

## Environment Variables

| Variable        | Beschreibung                                |
| --------------- | ------------------------------------------- |
| `EULA`          | Must be set to TRUE to accept the EULA      |
| `SHA1`          | SHA1 hash of the server.jar from Mojang     |
| `VERSION`       | Informational only (not directly used)      |
| `MEMORY`        | RAM allocation for the server (e.g., 2G)    |
| `MAX_PLAYERS`   | Max number of concurrent players            |
| `RCON_PASSWORD` | Optional for remote console access          |

---

## Projectstruktur

```text
.
├── Dockerfile                      # Builds server image using Java & SHA1 jar
├── docker-compose.yml              # Manages port, volume, and build settings
├── .gitignore                      # Excludes sensitive files like .env
├── .env.example                    # Configuration template file
├── Minecraft_Server_Checkliste     # DA Checklist
└── README.md                       # Readme file
```

---

## Testing

To verify the setup:
1. Run the container and connect using a Minecraft client
2. Check server status using mcstatus:

```bash
python3 -m pip install mcstatus
mcstatus YOUR_SERVER_IP:8888 status
```
Example output:
```bah
(minecraft-venv) PS C:\DEVELOPMENT\minecraft-server-status> python -m mcstatus localhost:8888 status
version: Java 1.21.8 (protocol 772)
motd: A Minecraft Server
players: 0/20 No players online
ping: 51.56 ms
```

3. Restart the server and verify world data persists
4. Stop the container and confirm it restarts automatically

---
