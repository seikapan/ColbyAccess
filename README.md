# Colby Access

Colby Access is a local web application for campus accessibility information. It includes a React client, TypeScript API, and PostgreSQL database.

## Prerequisites

- Node.js 20.19 or newer
- Docker Desktop

## Quick start

Run these commands from the repository root:

```bash
cp .env.example .env
npm install
npm run db:up
npm run db:seed
npm run dev
```

Open the application at http://localhost:5173. The API runs at http://localhost:3000.

## Database access

The local PostgreSQL database runs in Docker. Connect with Beekeeper Studio using:

| Field | Value |
| --- | --- |
| Connection type | PostgreSQL |
| Host | `localhost` |
| Port | `5432` |
| Database | `colby_access` |
| User | `colby_access` |
| Password | `colby_access` |
| SSL | Disabled |

Connection string:

```text
postgres://colby_access:colby_access@localhost:5432/colby_access
```

## Common commands

| Command | Purpose |
| --- | --- |
| `npm run dev` | Start the client and API |
| `npm run db:up` | Start PostgreSQL |
| `npm run db:down` | Stop PostgreSQL without deleting its data |
| `npm run db:migrate` | Apply pending database migrations |
| `npm run db:seed` | Apply migrations and replace local data with the demonstration seed |
| `npm run build` | Type-check and build the client and API |
| `npm run lint` | Run configured lint checks |

## Database changes

The first migration creates the schema. The current demonstration dataset lives in `db/seed.sql`; `npm run db:seed` runs it after applying migrations. Add later schema changes as ordered SQL files in `db/migrations`, then run `npm run db:migrate`.

During the disposable demonstration phase, rebuild the database from the rewritten first migration with:

```bash
docker compose down -v
npm run db:up
npm run db:seed
```
