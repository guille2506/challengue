<div align="center">
  <img src="assets/notes-portada.jpg" alt="Notes — portada" width="100%" />
</div>

# Notes — ejercicio Full Stack 🗒️

SPA para **crear, editar, eliminar, archivar y filtrar notas**, con **categorías** que se pueden adjuntar a las notas y usar como filtro. Todo persiste en **PostgreSQL** real vía JPA/Hibernate (nada de mocks ni memoria).

El proyecto se separa en dos aplicaciones independientes:

| Carpeta    | Stack                                      | Responsabilidad             |
|------------|--------------------------------------------|-----------------------------|
| `backend`  | Spring Boot 3 (Java 21) + Spring Data JPA  | API REST + persistencia     |
| `frontend` | React 18 + Vite + TypeScript               | SPA (UI)                    |

---

## 🚀 Clonar y correrlo

### Requisitos
- Java 21 + Maven (o `mvnw`), Node.js 18+
- Cada uno con su forma rápida:

### ⚡ Arranque rápido

**macOS / Linux** — un solo comando levanta TODO (Postgres vía Docker + backend + frontend):

```bash
git clone https://github.com/guille2506/challengue.git
cd challengue
./run.sh          # Ctrl+C para detener
./run.sh --stop   # para y elimina el contenedor de la base
```

**Windows** — doble clic:

```
arranque-rapido\levantar_notes.bat   → base :5433, backend :8090, Vite :5173
arranque-rapido\cerrar_notes.bat     → baja todo ordenado
```

> 🔧 Los valores por defecto se pueden pisar con variables de entorno:
> `DB_NAME` (notesdb), `DB_USER` (notes), `DB_PASSWORD` (notes),
> `DB_PORT` (5432), `SERVER_PORT` (8080).

⚠️ No olvides tener **Docker** corriendo en tu máquina — el `run.sh` levanta la base con docker-compose.

### Manual (por partes)

```bash
# backend  (port :8080)
cd backend && mvn spring-boot:run

# frontend (port :5173)
cd frontend && npm install && npm run dev
```

---

## ✨ Qué hace

**Fase 1**
- Crear / editar / eliminar notas
- Archivar / desarchivar
- Listar activas y archivadas

**Fase 2**
- Crear y borrar categorías
- Asociar categorías a una nota
- Filtrar notas por una o más categorías
- Búsqueda por texto (título, contenido y nombre de categoría)

---

## 📦 Estructura

```
challengue/
├── backend/            # Spring Boot 3 — API REST
├── frontend/           # React + Vite — SPA
├── arranque-rapido/    # .bat de Windows: levantar / cerrar
├── docker-compose.yml  # PostgreSQL
└── run.sh              # arranque full-stack en un comando
```

🔗 [Ver en mi portfolio](https://nuevoportfolio.vercel.app/works/detail/nt8zcq24vt/index.html)

---

<p align="center">
  <sub><b>moto</b> · hecho con cariño — <a href="https://nuevoportfolio.vercel.app/">portfolio</a></sub>
</p>
