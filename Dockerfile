FROM ubuntu:24.04 AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl unzip ca-certificates libssl3 libdbus-1-3 libstdc++6 git && \
    rm -rf /var/lib/apt/lists/*

# Install Lune
RUN curl -f -L "https://github.com/lune-org/lune/releases/download/v0.10.4/lune-0.10.4-linux-x86_64.zip" -o lune.zip && \
    unzip -j lune.zip && \
    chmod +x lune && \
    mv lune /usr/local/bin/lune && \
    rm lune.zip

# Install Pesde
RUN curl -f -L "https://github.com/pesde-pkg/pesde/releases/download/v0.7.2+registry.0.2.3/pesde-0.7.2-linux-x86_64.zip" -o pesde.zip && \
    unzip -j pesde.zip && \
    chmod +x pesde && \
    mv pesde /usr/local/bin/pesde && \
    rm pesde.zip

WORKDIR /app
COPY pesde.toml ./
RUN mkdir -p /root/.pesde && pesde install
COPY . .

# --- TEST STAGE ---
FROM base AS test
WORKDIR /app/ci
RUN lune run test

# --- Benchmark STAGE ---
FROM base AS final
WORKDIR /app/benchmark
EXPOSE 10000
CMD ["lune", "run", "start"]
