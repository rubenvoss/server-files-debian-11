#!/bin/bash
docker pull rubenvoss/rails-production:latest
docker stop rails_production_server
docker compose down
docker compose up --build
