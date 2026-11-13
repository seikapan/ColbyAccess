import { config } from 'dotenv'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const currentDirectory = resolve(fileURLToPath(new URL('.', import.meta.url)))

config({ path: resolve(currentDirectory, '../../../.env'), quiet: true })
