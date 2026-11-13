import cors from '@fastify/cors'
import Fastify from 'fastify'
import { closeDatabase, getDatabase } from './database/client.js'

const app = Fastify({ logger: true })

await app.register(cors, {
  origin: process.env.CLIENT_ORIGIN ?? 'http://localhost:5173',
})

app.get('/api/health', async () => {
  await getDatabase().query('select 1')

  return { status: 'ok' }
})

app.addHook('onClose', async () => {
  await closeDatabase()
})

const port = Number(process.env.API_PORT ?? 3000)

await app.listen({ host: '0.0.0.0', port })
