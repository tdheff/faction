import knex from 'knex'
import path from 'path'
import { createClient } from 'redis'

const config = {
  client: 'pg',
  connection: process.env.DATABASE_URL || {
    host: 'localhost',
    port: '5432',
    user: 'postgres',
    password: 'postgres',
    database: 'faction_dev'
  },
  migrations: {
    directory: path.join(__dirname, 'src', 'db', 'migrations')
  },
  seeds: {
    directory: path.join(__dirname, 'src', 'db', 'seeds')
  }
}

export const db = knex(config)

export const client = createClient()

// (async () => {
//   const client = createClient()

//   client.on('error', (err) => console.log('Redis Client Error', err))

//   await client.connect()

//   await client.set('key', 'value')
//   const value = await client.get('key')
// })()
