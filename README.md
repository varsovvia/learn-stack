# Learn Stack - Docker Compose + Caddy

Un stack completo para desarrollo y producción usando Docker Compose, Caddy como reverse proxy, y servicios separados para web, API y ML.

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Caddy Edge   │    │   Next.js Web   │    │   FastAPI API   │
│   (Reverse     │    │   (Frontend)     │    │   (Backend)     │
│    Proxy)      │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   FastAPI ML    │
                    │   (ML Service)  │
                    └─────────────────┘
```

## 🚀 Servicios

- **Caddy**: Reverse proxy con TLS automático
- **Web**: Aplicación Next.js
- **API**: Servicio FastAPI
- **ML**: Servicio ML con FastAPI

## 📁 Estructura del Proyecto

```
learn-stack/
├── compose.yml              # Configuración base
├── compose.dev.yml          # Override para desarrollo
├── compose.prod.yml         # Override para producción
├── caddy/
│   ├── Caddyfile.dev        # Configuración Caddy para desarrollo
│   └── Caddyfile.prod       # Configuración Caddy para producción
├── apps/
│   ├── web/                 # Aplicación Next.js
│   ├── api/                 # Servicio FastAPI
│   └── ml/                  # Servicio ML
├── scripts/
│   └── deploy.sh            # Script de despliegue
└── .github/workflows/       # CI/CD con GitHub Actions
```

## ⚙️ Configuración

### Variables de Entorno

Copia `env.example` a `.env` y configura:

```bash
# Caddy
ACME_EMAIL=admin@example.com
PROD_DOMAIN=example.com

# Puertos de servicios
WEB_PORT=3000
API_PORT=8000
ML_PORT=8001

# Límites de recursos (producción)
WEB_CPU=0.5
WEB_MEM=512M
API_CPU=0.5
API_MEM=512M
ML_CPU=1.0
ML_MEM=1G
```

## 🚀 Despliegue

### Desarrollo

```bash
# Validar configuración
docker compose -f compose.yml -f compose.dev.yml config

# Iniciar servicios
docker compose -f compose.yml -f compose.dev.yml up -d

# Ver logs
docker compose -f compose.yml -f compose.dev.yml logs -f
```

### Producción

```bash
# Usar script de despliegue
chmod +x scripts/deploy.sh
./scripts/deploy.sh prod

# O manualmente
docker compose -f compose.yml -f compose.prod.yml up -d --build
```

### Script de Despliegue

```bash
# Despliegue en desarrollo
./scripts/deploy.sh dev

# Despliegue en producción
./scripts/deploy.sh prod
```

## 🌐 Enrutamiento

### Desarrollo
- **URL**: `http://localhost` o `https://MI_IP.sslip.io`
- **Rutas**:
  - `/` → Next.js Web
  - `/api/*` → FastAPI API
  - `/ml/*` → ML Service

### Producción
- **URL**: `https://tu-dominio.com`
- **Rutas**: Igual que desarrollo pero con TLS

## 🔧 Mejoras Implementadas

### Producción
- ✅ Límites de recursos por servicio
- ✅ Múltiples workers para FastAPI
- ✅ Restart policies
- ✅ Replicas para escalabilidad

## 🚧 Próximos Pasos

1. **Monitoreo**: Agregar Prometheus + Grafana
2. **Logs**: Centralizar logs con ELK stack
3. **Backup**: Automatizar backups de volúmenes
4. **SSL**: Configurar certificados personalizados
5. **CI/CD**: Completar pipeline de GitHub Actions
6. **Multi-cliente**: Preparar para futuros despliegues multi-tenant (cuando domines dev/prod)

## 🐛 Troubleshooting

### Problemas Comunes

1. **Puertos ocupados**: Verificar que 80, 443, 3000, 8000, 8001 estén libres
2. **Variables de entorno**: Asegurar que `.env` esté configurado
3. **Permisos**: Verificar permisos en `scripts/deploy.sh`

### Comandos Útiles

```bash
# Ver estado de servicios
docker compose -f compose.yml -f compose.dev.yml ps

# Ver logs de un servicio específico
docker compose -f compose.yml -f compose.dev.yml logs caddy

# Reconstruir un servicio
docker compose -f compose.yml -f compose.dev.yml build web

# Parar todos los servicios
docker compose -f compose.yml -f compose.dev.yml down
```

## 📚 Recursos

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Caddy Documentation](https://caddyserver.com/docs/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)

## 📖 Documentación Adicional

- [Guía Dev/Prod](DEV_PROD_GUIDE.md) - Explicación detallada del flujo dev/prod

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.
