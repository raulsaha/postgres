# Docker

We can install PostgreSQL in different ways. Once of them is through Docker.

We can get docker images from docker hub from this [link]( https://hub.docker.com/_/postgres)

## Different ways to run PostgreSQL docker

- Run mode
- Compose Mode

### Run Mode

When we do not want much customization, run mode is way to go. Below is a simple example -

Create the container:

```
docker run --name postgres-simple -e POSTGRES_PASSWORD=anypassword -d postgres
```

List the container:

```
docker ps
```

Enter the container:

```
docker exec -it postgres-simple bash
```

Login to PostgreSQL:

```
psql -h localhost -U postgres
```

Remove the container:

```
docker rm -f postgres-simple
```

Above steps will delete the data directory when we remove the continer. We can keep the data directory persistent even after removing the container. We also mention specific version so that we can maintain the version.

```
docker run -it --rm --name postgres-persistent `
  -e POSTGRES_PASSWORD=anypassword `
  -v ${PWD}/pgdata:/var/lib/postgresql/data `
  postgres:17.2
```




