# Free5GC (Lab 3)

Free5GC is easiest to reproduce with the official **Docker Compose** bundle.

This lab clones upstream `free5gc-compose` next to this README (or uses `FREE5GC_COMPOSE_DIR` if already present) and brings the stack up.

References:

- https://github.com/free5gc/free5gc-compose

## Notes

- Free5GC containers are resource-heavy; a **16 GB RAM** VM is appropriate.
- First `docker compose pull` may take several minutes.
