# Minimaler Java-Basiscontainer
FROM eclipse-temurin:21-jdk-jammy

# Build-Arguments of docker-compose.yml
ARG VERSION
ARG EULA
ARG MEMORY
ARG SHA1
ARG MAX_PLAYERS=20
ARG MOTD="Minecraft Server"
ARG RCON_PASSWORD

# Environment variables
ENV VERSION=${VERSION}
ENV EULA=${EULA}
ENV MEMORY=${MEMORY}
ENV SHA1=${SHA1}
ENV MAX_PLAYERS=${MAX_PLAYERS}
ENV MOTD=${MOTD}
ENV RCON_PASSWORD=${RCON_PASSWORD}

# Working directory of Container
WORKDIR /server

# Install curl and load server.jar based on SHA1-Hash from Mojang
RUN apt-get update && apt-get install -y curl && \
    curl -o server.jar https://launcher.mojang.com/v1/objects/${SHA1}/server.jar && \
    echo "eula=${EULA}" > eula.txt 

# Expose Minecraft port
EXPOSE 25565

# Start Minecraft-Server with RAM config and additional properties.
CMD sh -c "echo 'max-players=${MAX_PLAYERS}' >> server.properties && \
    echo "motd='${MOTD}'" >> server.properties && \
    echo 'rcon.password=${RCON_PASSWORD}' >> server.properties && \
    java -Xmx${MEMORY} -Xms${MEMORY} -jar server.jar nogui"
