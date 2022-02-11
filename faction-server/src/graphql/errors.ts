interface ClientError {
  code: string
  message: string
}

export class PasswordsDontMatchError implements ClientError {
  code = 'PASSWORDS_DONT_MATCH'
  message = 'Passwords do not match one another'
}

export class UserDoesNotExistError implements ClientError {
  code = 'USER_DOES_NOT_EXIST'
  message = 'No account exists for this email address'
}

export class IncorrectCredentialsError implements ClientError {
  code = 'INCORRECT_CREDENTIALS'
  message = 'Incorrect email or password'
}
