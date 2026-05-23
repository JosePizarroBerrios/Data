FROM mysql:8.0

COPY database/01_creacion_base_datos.sql /docker-entrypoint-initdb.d/
COPY database/02_backup_y_mantenimiento.sql /docker-entrypoint-initdb.d/

# Modificamos directamente el archivo de configuración nativo de la imagen
RUN echo "[mysqld]" >> /etc/mysql/conf.d/custom.cnf && \
    echo "bind-address = 0.0.0.0" >> /etc/mysql/conf.d/custom.cnf && \
    echo "character-set-server = utf8mb4" >> /etc/mysql/conf.d/custom.cnf && \
    echo "collation-server = utf8mb4_unicode_ci" >> /etc/mysql/conf.d/custom.cn
#comentario
EXPOSE 3306