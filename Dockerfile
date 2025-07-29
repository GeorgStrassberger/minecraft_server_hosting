# Minimaler Java-Basiscontainer
FROM eclipse-temurin:21-jdk-jammy

# Build-Arguments of docker-compose.yml
ARG VERSION
ARG EULA
ARG MEMORY
ARG SHA1

# Environment variables
ENV VERSION=${VERSION}
ENV EULA=${EULA}
ENV MEMORY=${MEMORY}
ENV SHA1=${SHA1}

# Working directory of Container
WORKDIR /server

# Install curl and load server.jar based on SHA1-Hash from Mojang
RUN apt-get update && apt-get install -y curl && \
    curl -o server.jar https://launcher.mojang.com/v1/objects/${SHA1}/server.jar && \
    echo "eula=${EULA}" > eula.txt

# Expose Minecraft port
EXPOSE 25565

# Start Minecraft-Server with RAM config
CMD sh -c "java -Xmx${MEMORY} -Xms${MEMORY} -jar server.jar nogui"
