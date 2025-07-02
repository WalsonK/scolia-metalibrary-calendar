# Étape 1 : Build Rust
FROM rust:latest as builder

WORKDIR /src

# Copie uniquement les fichiers nécessaires pour le cache des dépendances
COPY Cargo.toml Cargo.lock ./
RUN cargo fetch

# Copie le reste des fichiers et compile
COPY . .
RUN cargo build --release && test -f target/release/librustlib.so

# Étape 2 : Copie minimale dans une image légère
FROM busybox

# Dossier partagé via bind mount
VOLUME ["/shared"]

# Copie la bibliothèque compilée vers le dossier partagé
COPY --from=builder /src/target/release/librustlib.so /shared/librustlib.so
