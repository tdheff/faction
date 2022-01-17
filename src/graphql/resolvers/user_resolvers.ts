import { createUser, getUser, login } from '../../domains/accounts/user_controller'
import { CreateUserInput, LoginInput } from '../../domains/accounts/user_types'

export const User = {

}

export const UserQuery = {
  user: async (_: any, { id }: {id: number}) => {
    return await getUser(id)
  }
}

export const UserMutation = {
  createUser: async (_: any, { input }: { input: CreateUserInput }) => {
    return await createUser(input)
  },
  login: async (_: any, { input }: { input: LoginInput }) => {
    return await login(input)
  }
}
