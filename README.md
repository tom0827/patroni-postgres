# patroni-postgres

## Project Overview

This repository provides the necessary files to build a custom Docker image for running PostgreSQL with Patroni, designed for deployment in OpenShift environments. Patroni is a template for PostgreSQL high-availability, and this image aims to simplify the setup and management of highly available PostgreSQL clusters on OpenShift.

The project includes:
- A Dockerfile for building the image
- Scripts for entrypoint, post-initialization, and health checks
- Example configuration and documentation (to be expanded)

This image is intended for use as a base in OpenShift projects requiring robust, production-ready PostgreSQL with automatic failover and cluster management via Patroni.
