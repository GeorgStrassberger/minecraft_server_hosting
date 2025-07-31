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
  - [Project structur](#project-structur)
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
   git clone git@github.com:GeorgStrassberger/minecraft_server_hosting.git
   cd minecraft_server_hosting
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

This is a JSON file containing all official versions.

```js
latest:	{ release: "1.21.8", snapshot: "25w31a" },
versions: [
   { id: "25w31a", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/6ec665b6b0b60df1d0ffe92812bf7a860a4953ea/25w31a.json", … },
   { id: "1.21.8", type: "release", url: "https://piston-meta.mojang.com/v1/packages/24b08e167c6611f7ad895ae1e8b5258f819184aa/1.21.8.json", … },
   { id: "1.21.8-rc1", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/d2573833c5dc21fb1e9033b3d7b912168786cd1b/1.21.8-rc1.json", … },
   { id: "1.21.7", type: "release", url: "https://piston-meta.mojang.com/v1/packages/cd36d4744092cc0cca8d3fbf8e9222b0fdc00541/1.21.7.json", … },
   { id: "1.21.7-rc2", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/b9e024e78ab57a6d1e72c7d047d25c3140adc439/1.21.7-rc2.json", … },
   { id: "1.21.7-rc1", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/6b949410815e34f47301eb610b8063833aac9473/1.21.7-rc1.json", … },
   { id: "1.21.6", type: "release", url: "https://piston-meta.mojang.com/v1/packages/e2a26a825f525a8cc72066d632d07aa8af67b19a/1.21.6.json", … },
   { id: "1.21.6-rc1", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/dda6dc2c16765e4a3819a9f985baf659ee14bd2d/1.21.6-rc1.json", … },
   { id: "1.21.6-pre4", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/4fa7a83b157486431d8e4267fe95fe9dcabf0d49/1.21.6-pre4.json", … },
   { id: "1.21.6-pre3", type: "snapshot", url: "https://piston-meta.mojang.com/v1/packages/938dac32ffc4a6c064c2cbf89e9dfd1920ec8a50/1.21.6-pre3.json", … }
]
```



2. Find your version (e.g. `id:1.21.8` & `type: release`) in the list:

```js
{
   id: "1.21.8",
   type: "release",
   url: "https://piston-meta.mojang.com/v1/packages/24b08e167c6611f7ad895ae1e8b5258f819184aa/1.21.8.json",
   time: "2025-07-17T12:13:03+00:00",
   releaseTime: "2025-07-17T12:04:02+00:00"
}

```

1. Copy the associated url, for example:

```json
"url": "https://piston-meta.mojang.com/v1/packages/24b08e167c6611f7ad895ae1e8b5258f819184aa/1.21.8.json"
```

4. Open that URL and look for:

```json
"downloads": {
   "server": {
      "sha1": "6bce4ef400e4efaa63a13d5e6f6b500be969ef81",
      "url": "https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar"
   },
   "id":"1.21.8"
}
```

5. Copy the sha1 value and paste it into your `.env`:

```bash
SHA1=6bce4ef400e4efaa63a13d5e6f6b500be969ef81
```

---

## Environment Variables

| Variable        | Description                                |
| --------------- | ------------------------------------------- |
| `EULA`          | Must be set to TRUE to accept the EULA      |
| `SHA1`          | SHA1 hash of the server.jar from Mojang     |
| `VERSION`       | Informational only (not directly used)      |
| `MEMORY`        | RAM allocation for the server (e.g., 2G)    |
| `MOTD`          | Message of the Day                          |
| `MAX_PLAYERS`   | Max number of concurrent players            |
| `RCON_PASSWORD` | Optional for remote console access          |

> **Hint:**
> If you want to specify additional properties, you can find a list of all properties under [www.minecraftinfo.de](https://www.minecraftinfo.de/wiki/minecraft-server-server-properties-erklaert/).
Add it to the `.env` file. Then declare the `ARG` in the Dockerfile and initialize the `ENV` variable with the key from the `.env` file. Finally, adjust the `CMD` command with `“echo ‘mc_propertiename=${ENV_NAME}’ >> server.properties && \”`. This will overwrite the default value.

---

## Project structur

```text
./minecraft_server_hosting
├── Dockerfile                      # Builds server image using Java & SHA1 jar
├── docker-compose.yml              # Manages port, volume, and build settings
├── .gitignore                      # Excludes sensitive files like .env
├── .env.example                    # Configuration template file
├── Minecraft_Server_Checkliste.pdf # DA Checklist
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
