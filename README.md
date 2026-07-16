# Attune Docker

Run Attune Services from published container images without cloning or building the application source.

## Start

Requirements: Docker Engine and Docker Compose v2.

```sh
git clone <this-repository-url> attune-docker
cd attune-docker
./scripts/create-env.sh
docker compose pull
docker compose up -d
```

Open:

| Service | Address |
| --- | --- |
| Web UI | http://localhost:3000 |
| API | http://localhost:8080 |
| API docs | http://localhost:8080/api-spec/swagger-ui/ |
| Notifier WebSocket | ws://localhost:8081/ws |

Sign in with the values in `.env`: by default, `test@attune.local` and
`TestPass123!`. Change `ATTUNE_TEST_PASSWORD` before the first startup to
create a different initial account password.

## Images

The Compose stack pulls all Attune services and bootstrap jobs from
`ghcr.io/attune-system`: API, executor, supervisor, notifier, web, agent,
migrations, user initialization, and core-pack initialization. The only local
application file mounted into containers is `config.docker.yaml`.

`edge` is the newest tag currently published for every required Attune image;
the registry does not currently provide a `latest` tag. To select another
published version, change `ATTUNE_IMAGE_TAG` in `.env` before pulling:

```sh
docker compose pull
docker compose up -d
```

Keep every Attune image on the same tag. The Compose file defaults to `edge`
when no `.env` is present, but startup requires the generated secrets in
`.env`.

## Operations

```sh
# Follow startup and application logs
docker compose logs -f

# Stop the stack while retaining data
docker compose down

# Remove all Attune data and start over
docker compose down -v
```

PostgreSQL and RabbitMQ ports are exposed for local development. Do not expose
this default Compose deployment directly to the internet; place the web and API
services behind an authenticated TLS reverse proxy for shared environments.
