import { Knex } from 'knex'

export async function up (knex: Knex): Promise<void> {
  return knex.schema.createTable('users', users => {
    users.increments('id').unsigned().primary()
    users.string('name').notNullable()
    users.string('email')
    users.string('password_hash')

    users.timestamp('created_at').defaultTo(knex.fn.now())
    users.timestamp('updated_at')

    users.unique(['email'])
  })
}

export async function down (knex: Knex): Promise<void> {
  knex.schema.dropTable('users')
}
