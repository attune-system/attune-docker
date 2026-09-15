# Attune Docker

Run Attune Services from published container images without cloning or building the application source.

## Start

Requirements: Docker Engine and Docker Compose v2.

```sh
git clone https://github.com/attune-system/attune-docker.git attune-docker
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

Fresh databases include a pinned **Attune Standard Pack Index** snapshot at:

```text
https://raw.githubusercontent.com/attune-system/index/793aabcc0eb537af7681a386b591de6c4fafd7a1/index.json
```

It can be reordered, disabled, or permanently deleted through normal pack
index administration. `config.docker.yaml` approves only the public hosts used
by that index and its GitHub install sources. Set
`pack_registry.approved_public_hosts: []` to opt out of public registry and pack
source traffic by default. Add the live `main` index separately only if catalog
changes independent of Attune releases are desired.

The standard entries prefer Git and fall back on failure to independently
checksummed archives from `codeload.github.com`, so that host is required by
the pinned index. Attune verifies and records the checksum of the source
actually installed and rejects content whose `pack.yaml` ref or version does
not match the selected entry.

Direct remote Git/archive installs bypass index checksums. This Docker setup
enables them for the approved public hosts so explicit URL installs work out of
the box. Prefer registry references, and set
`pack_registry.allow_unverified_direct_remote_installs: false` for a locked-down
deployment.

Use `attune pack install <ref> --registry-id <id>` to pin an install to one
enabled managed index. `--no-registry` requires an explicit URL or a path
already visible inside the API container and never performs registry lookup.

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
