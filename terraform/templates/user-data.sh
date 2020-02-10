#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
  echo "ECS_ENABLE_TASK_IAM_ROLE=true"
} >> /etc/ecs/ecs.config

echo "Done"
