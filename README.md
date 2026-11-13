# Colby Access

Colby Access is a React and TypeScript web application backed by a TypeScript API and PostgreSQL.

## Local development

1. Copy `.env.example` to `.env`.
2. Run `npm install`.
3. Run `npm run db:up`.
4. Run `npm run db:migrate`.
5. Run `npm run dev`.

The web client runs at `http://localhost:5173`; the API runs at `http://localhost:3000`.

## Database

PostgreSQL runs in Docker with a named volume so data persists across container restarts. Add each ER-diagram-backed schema change as an ordered SQL migration in `db/migrations`, then run `npm run db:migrate`.

## Commands

| Command | Purpose |
| --- | --- |
| `npm run build` | Type-check and build the client and API |
| `npm run db:up` | Start PostgreSQL |
| `npm run db:down` | Stop PostgreSQL |
| `npm run db:migrate` | Apply pending SQL migrations |
| `npm run dev` | Start the API and Vite client |
| `npm run lint` | Run workspace linting where configured |
