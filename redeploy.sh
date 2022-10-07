#!/bin/bash
docker pull rubenvoss/rails-production:latest
docker compose down
docker compose up --build
