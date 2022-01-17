import { User, UserQuery, UserMutation } from './resolvers/user_resolvers'

export default {
  Query: {
    ...UserQuery
  },
  Mutation: {
    ...UserMutation
  },
  User
}
