# syntax=docker/dockerfile:1.4
FROM ghcr.io/rocker-org/devcontainer/r-ver:4.2

# Install system dependencies required for building R packages (e.g., sf)
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libudunits2-dev \
      libgdal-dev \
      libgeos-dev \
      libproj-dev && \
    rm -rf /var/lib/apt/lists/*
