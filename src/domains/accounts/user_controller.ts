import { randomBytes } from 'crypto'
import bcrypt from 'bcrypt'
import { client, db } from '../../db'
import { IncorrectCredentialsError, PasswordsDontMatchError, UserDoesNotExistError } from '../../graphql/errors'
import { CreateUserInput, LoginInput, User } from './user_types'

export async function getUser (id: number) {
  return await db('users')
    .where({ id })
    .first()
}

export async function createUser (input: CreateUserInput) {
  if (input.password !== input.passwordConfirmation) {
    return {
      success: false,
      error: new PasswordsDontMatchError()
    }
  }

  const passwordHash = await bcrypt.hash(input.password, 10)

  const userToCreate = {
    name: input.name,
    email: input.email,
    password_hash: passwordHash
  }

  const usersCreated = await db('users')
    .insert(userToCreate)
    .returning('*')

  return {
    success: true,
    data: usersCreated[0]
  }
}

export async function login (input: LoginInput) {
  const userRows = await db.from<User, User>('users')
    .select(['password_hash as passwordHash', 'id'])
    .where({ email: input.email })

  if (userRows.length < 1) {
    return {
      success: false,
      error: new UserDoesNotExistError()
    }
  }

  const valid = await bcrypt.compare(input.password, userRows[0].passwordHash)
  if (!valid) {
    return {
      success: false,
      error: new IncorrectCredentialsError()
    }
  }

  const token = randomBytes(64).toString('hex')

  await client.set(`user-token:${token}`, 'userId', userRows[0].id)

  return {
    success: true,
    data: token
  }
}
