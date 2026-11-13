import { readFile } from 'node:fs/promises'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { closeDatabase, getDatabase } from './client.js'

const currentDirectory = resolve(fileURLToPath(new URL('.', import.meta.url)))
const seedFile = resolve(currentDirectory, '../../../db/seed.sql')

async function seed() {
  const database = getDatabase()
  const seedSql = await readFile(seedFile, 'utf8')
  const client = await database.connect()

  try {
    await client.query('begin')
    await client.query(seedSql)
    await client.query('commit')
  } catch (error) {
    await client.query('rollback')
    throw error
  } finally {
    client.release()
  }
}

try {
  await seed()
} finally {
  await closeDatabase()
}
