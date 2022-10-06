#!bin/bash

docker pull rubenvoss/rails-production:latest
docker stop rails_production_server
docker system prune -f
docker run -d --name=rails_production_server rubenvoss/rails-production:latest
