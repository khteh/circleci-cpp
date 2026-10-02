#!/bin/bash
#$(aws ecr get-login --no-include-email)
# Use --progress=plain to see command outputs
docker build -t circleci-cpp .
docker tag circleci-cpp:latest khteh/circleci-cpp:latest
docker push khteh/circleci-cpp:latest
