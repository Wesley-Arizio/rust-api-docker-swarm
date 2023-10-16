FROM rust:bullseye as builder
WORKDIR /rust-server-docker-swarm-deploy

# Copy the source code
COPY . .

# Build application
RUN cargo build --release

FROM debian:bullseye-slim

RUN apt-get update \
    && apt-get install -y extra-runtime-dependencies \
    && apt-get install -y ca-certificates \
    & rm -rf /var/lib/apt/lists/*

COPY --from=builder /rust-server-docker-swarm-deploy/target/release/rust-server-docker-swarm-deploy /rust-server-docker-swarm-deploy

EXPOSE 8080

CMD "./rust-server-docker-swarm-deploy"