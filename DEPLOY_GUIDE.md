# Guía de despliegue — Resumen conciso

Objetivo: construir la imagen, subir a Docker Hub y desplegar en una EC2 privada vía Bastion usando Docker Compose.

Archivos clave:
- [dockerfile](dockerfile): crea imagen MySQL y copia scripts de inicialización a `/docker-entrypoint-initdb.d/`.
- [docker-compose.yml](docker-compose.yml): define `image: ${DOCKERHUB_USERNAME}/proyecto_db:latest`, puerto 3306, variables `MYSQL_*` y volumen persistente.
- [Data_Eval2/workflows/deploy.yml](Data_Eval2/workflows/deploy.yml): CI/CD — `build-and-push` → `deploy-to-ec2` (scp + ssh vía Bastion).

Fix crítico detectado:
- `deploy.yml` copia `compose.yml` pero el repo tiene `docker-compose.yml`. Corregir `source` a `docker-compose.yml` o añadir un paso `cp docker-compose.yml compose.yml`.

Secrets necesarios (configurar en GitHub):
- `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`, `EC2_PRIVATE_IP`, `EC2_USER`, `EC2_SSH_KEY`, `BASTION_HOST`, `BASTION_USER`, `BASTION_SSH_KEY`, `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`.

Comandos rápidos (local):
```
# Crear .env con variables (DOCKERHUB_USERNAME, MYSQL_*)
docker build -t $DOCKERHUB_USERNAME/proyecto_db:latest -f dockerfile .
docker compose up -d
```

Notas clave:
- Los scripts en `/docker-entrypoint-initdb.d/` solo se ejecutan con un volumen nuevo.
- No exponer MySQL a Internet; usar VPC/firewall/VPN.
- Etiquetar imágenes con SHA además de `latest` para trazabilidad.

¿Deseas que aplique la corrección al workflow (`source: "docker-compose.yml"`) o que añada un `compose.yml` copia de `docker-compose.yml`?
