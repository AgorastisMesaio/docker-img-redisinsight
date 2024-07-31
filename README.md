# RedisInsight docker container

![GitHub action workflow status](https://github.com/AgorastisMesaio/docker-img-redisinsight/actions/workflows/docker-publish.yml/badge.svg)

This repository contains a `Dockerfile` aimed to create a *base image* to provide a dockerized RedisInsight. RedisInsight is a graphical user interface (GUI) tool designed to help developers and database administrators manage and optimize Redis databases. It provides a user-friendly interface to visualize data, monitor performance, and perform various administrative tasks.

## Use Cases

- Data Visualization. RedisInsight allows users to visually explore their Redis data. This includes viewing and editing keys, examining data structures, and browsing through datasets in a more intuitive manner compared to command-line interfaces.

   Performance Monitoring. Users can monitor the performance of their Redis instances in real-time. RedisInsight provides insights into memory usage, CPU load, command execution times, and other key performance metrics, helping to identify and troubleshoot issues quickly.

- Query Execution. RedisInsight offers a query editor for executing Redis commands. This feature supports syntax highlighting, auto-completion, and inline documentation, making it easier to write and execute commands efficiently.

- Analyzing Query Performance. Users can analyze the performance of specific queries, identify slow commands, and understand the impact of various operations on the database. This helps in optimizing queries and improving overall database performance.

- Database Management. RedisInsight provides tools for managing Redis databases, such as creating and deleting keys, importing and exporting data, and managing database settings. It simplifies routine administrative tasks and improves productivity.

- Data Backup and Restoration. Users can backup and restore Redis data using RedisInsight. This feature is crucial for data protection and disaster recovery, ensuring that critical data is safely stored and can be restored when needed.

- Cluster Management. For users with Redis clusters, RedisInsight offers features to manage and monitor cluster nodes, view cluster topology, and perform operations like adding or removing nodes. This helps in maintaining and scaling Redis clusters effectively.

- Security Management. RedisInsight provides security management features, such as configuring access control lists (ACLs), managing user permissions, and monitoring security events. This ensures that Redis instances are secure and comply with organizational policies.

- Troubleshooting and Debugging. The tool aids in troubleshooting and debugging Redis instances by providing detailed logs, error messages, and diagnostic information. This helps in identifying and resolving issues quickly and efficiently.

- Education and Training. RedisInsight can be used as an educational tool to teach new users about Redis. Its intuitive interface and comprehensive features make it an excellent resource for learning and training purposes.

## Sample `docker-compose.yml`

This is an example where I'm running Redis together with Redisinsight. The Redis image is described in this github project.

```yaml
### Docker Compose example
volumes:
  redis_data:
    driver: local
  redisinsight_data:
    driver: local

networks:
  my_network:
    name: my_network
    driver: bridge

services:
  ct_redis:
    image: ghcr.io/agorastismesaio/base-redis:main
    hostname: redis
    container_name: ct_redis
    restart: always
    ports:
      - 6379:6379
    command:
      sh -c "/init.sh"
    privileged: true
    volumes:
      - redis_data:/data
    networks:
      - my_network

  ct_redisinsight:
    image: ghcr.io/agorastismesaio/docker-img-redisinsight:main
    hostname: redisinsight
    container_name: ct_redisinsight
    restart: always
    ports:
      - 5540:5540 # Management UI
    volumes:
      - redisinsight_data:/data
    networks:
      - my_network
    depends_on:
      - redis

  ct_other_container:
    :

  ct_other_container:
    :

  ct_other_container:
    :
```

- Start your services

```sh
docker compose up --build -d
```

## For developers

If you copy or fork this project to create your own base image.

### Building the Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t your-image/docker-img-redisinsight:main .
```

### Troubleshoot

```sh
docker run --rm --name ct_redisinsight --hostname redisinsight -p 6379:6379 your-image/docker-img-redisinsight:main
```
