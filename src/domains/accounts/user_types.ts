export interface User {
  id: number
  name: string
  email: string
  passwordHash: string
}

export interface CreateUserInput {
  name: string
  email: string
  password: string
  passwordConfirmation: string
}

export interface UpdateUserInput {
  name: string
  currentPassword: string
  password: string
  passwordConfirmation: string
}

export interface LoginInput {
  email: string
  password: string
}
