# Guía Dev/Prod - Learn Stack

Esta guía explica cómo funciona el flujo de desarrollo y producción en tu stack.

## 🔄 Flujo de Trabajo

### 1. Desarrollo Local
```bash
# Usar configuración de desarrollo
docker compose -f compose.yml -f compose.dev.yml up -d

# Resultado:
# - Caddy expone puertos 80/443
# - Usa Caddyfile.dev (HTTP sin SSL)
# - Servicios con hot reload
# - Volúmenes montados para desarrollo
```

### 2. Producción
```bash
# Usar configuración de producción
docker compose -f compose.yml -f compose.prod.yml up -d

# Resultado:
# - Caddy expone puertos 80/443
# - Usa Caddyfile.prod (HTTPS con SSL automático)
# - Servicios optimizados para producción
# - Límites de recursos configurados
```

## 📋 Diferencias Clave

| Aspecto | Desarrollo | Producción |
|---------|------------|------------|
| **Caddy** | HTTP, puertos 80/443 | HTTPS, puertos 80/443 |
| **SSL** | No | Sí (Let's Encrypt) |
| **Hot Reload** | Sí | No |
| **Volúmenes** | Montados del host | Copiados en imagen |
| **Recursos** | Sin límites | CPU/Memory limitados |
| **Workers** | 1 por servicio | Múltiples workers |

## 🚀 Comandos Esenciales

### Validación
```bash
# Validar configuración de desarrollo
docker compose -f compose.yml -f compose.dev.yml config

# Validar configuración de producción
docker compose -f compose.yml -f compose.prod.yml config
```

### Despliegue
```bash
# Desarrollo
./scripts/deploy.sh dev

# Producción
./scripts/deploy.sh prod
```

### Gestión de Servicios
```bash
# Ver logs de desarrollo
docker compose -f compose.yml -f compose.dev.yml logs -f

# Ver logs de producción
docker compose -f compose.yml -f compose.prod.yml logs -f

# Parar servicios
docker compose -f compose.yml -f compose.dev.yml down
```

## 🔧 Configuración de Variables

### Desarrollo (.env)
```bash
# Solo puertos básicos
WEB_PORT=3000
API_PORT=8000
ML_PORT=8001
NODE_ENV=development
```

### Producción (.env)
```bash
# Puertos + recursos + dominio
WEB_PORT=3000
API_PORT=8000
ML_PORT=8001
PROD_DOMAIN=tu-dominio.com
ACME_EMAIL=admin@tu-dominio.com
WEB_CPU=0.5
WEB_MEM=512M
# ... etc
```

## 🌐 URLs de Acceso

### Desarrollo
- **Web**: `http://localhost/` o `http://MI_IP.sslip.io/`
- **API**: `http://localhost/api/` o `http://MI_IP.sslip.io/api/`
- **ML**: `http://localhost/ml/` o `http://MI_IP.sslip.io/ml/`

### Producción
- **Web**: `https://tu-dominio.com/`
- **API**: `https://tu-dominio.com/api/`
- **ML**: `https://tu-dominio.com/ml/`

## 📊 Monitoreo

### Estado de Servicios
```bash
# Ver estado en desarrollo
docker compose -f compose.yml -f compose.dev.yml ps

# Ver estado en producción
docker compose -f compose.yml -f compose.prod.yml ps
```

### Recursos
```bash
# Ver uso de recursos
docker stats

# Ver logs específicos
docker compose -f compose.yml -f compose.prod.yml logs caddy
```

## 🚨 Troubleshooting

### Problema: Caddy no inicia
```bash
# Verificar configuración
docker compose -f compose.yml -f compose.dev.yml config

# Ver logs de Caddy
docker compose -f compose.yml -f compose.dev.yml logs caddy
```

### Problema: Servicios no responden
```bash
# Verificar estado
docker compose -f compose.yml -f compose.dev.yml ps

# Verificar redes
docker network ls
docker network inspect learn-stack_appnet
```

### Problema: Puertos ocupados
```bash
# Ver qué usa los puertos
netstat -tulpn | grep :80
netstat -tulpn | grep :443

# Parar servicios existentes
docker compose -f compose.yml -f compose.dev.yml down
```

## 🔄 Migración Dev → Prod

1. **Preparar variables de entorno**
   ```bash
   cp env.example .env
   # Editar .env con valores de producción
   ```

2. **Validar configuración**
   ```bash
   docker compose -f compose.yml -f compose.prod.yml config
   ```

3. **Desplegar**
   ```bash
   ./scripts/deploy.sh prod
   ```

4. **Verificar**
   ```bash
   docker compose -f compose.yml -f compose.prod.yml ps
   curl -f https://tu-dominio.com/health
   ```

## 💡 Consejos

- **Siempre valida** la configuración antes de desplegar
- **Usa el script** de despliegue para consistencia
- **Monitorea logs** después de cambios
- **Prueba endpoints** después del despliegue
- **Mantén backups** de archivos de configuración
