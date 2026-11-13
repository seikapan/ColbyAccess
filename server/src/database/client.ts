import pg from 'pg'
import './environment.js'

const { Pool } = pg

let database: pg.Pool | undefined

export function getDatabase() {
  const connectionString = process.env.DATABASE_URL

  if (!connectionString) {
    throw new Error('DATABASE_URL is required')
  }

  database ??= new Pool({ connectionString })

  return database
}

export async function closeDatabase() {
  await database?.end()
  database = undefined
}
