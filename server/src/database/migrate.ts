import { readdir, readFile } from 'node:fs/promises'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { closeDatabase, getDatabase } from './client.js'

const currentDirectory = resolve(fileURLToPath(new URL('.', import.meta.url)))
const migrationsDirectory = resolve(currentDirectory, '../../../db/migrations')

async function migrate() {
  const database = getDatabase()
  const migrationFiles = (await readdir(migrationsDirectory))
    .filter((file) => file.endsWith('.sql'))
    .sort()

  await database.query(`
    create table if not exists schema_migrations (
      name text primary key,
      applied_at timestamptz not null default now()
    )
  `)

  const { rows } = await database.query<{ name: string }>('select name from schema_migrations')
  const appliedMigrations = new Set(rows.map(({ name }) => name))

  for (const name of migrationFiles) {
    if (appliedMigrations.has(name)) {
      continue
    }

    const migration = await readFile(resolve(migrationsDirectory, name), 'utf8')
    const client = await database.connect()

    try {
      await client.query('begin')
      await client.query(migration)
      await client.query('insert into schema_migrations (name) values ($1)', [name])
      await client.query('commit')
    } catch (error) {
      await client.query('rollback')
      throw error
    } finally {
      client.release()
    }
  }
}

try {
  await migrate()
} finally {
  await closeDatabase()
}
