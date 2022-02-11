import { ApolloServer } from 'apollo-server-express'
import express from 'express'
import cors from 'cors'
import morgan from 'morgan'
import { json } from 'body-parser'
import { typeDefs } from './graphql/schema'
import resolvers from './graphql/resolvers'
import { client } from './db'

async function main () {
  const app = express()

  // app.use(helmet())
  app.use(json())
  app.use(cors())
  app.use(morgan('combined'))

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: ({ req }) => {
      const token = req.headers.authorization || ''
      return { token }
    }
  })
  await server.start()
  server.applyMiddleware({
    app,
    path: '/graphql'
  })

  client.on('error', (err) => console.log('Redis Client Error', err))
  await client.connect()

  app.listen({
    port: 8000
  }, () => {
    console.log('Apollo Server on http://localhost:8000/graphql')
  })
}

main()
