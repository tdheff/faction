import { gql } from 'apollo-server'

export const typeDefs = gql`
  scalar EmailAddress
  scalar Color
  scalar Date

  ###########
  # GENERIC #
  ###########

  type ClientError {
    code: String
    message: String
  }

  interface IRequest {
    success: Boolean
    error: ClientError
  }

  ############
  # ACCOUNTS #
  ############

  type User {
    id: ID!
    name: String!
    email: EmailAddress!
  }

  #########
  # GAMES #
  #########

  enum UnitTypes {
    LAND,
    SEA
  }

  enum Seasons {
    SPRING,
    FALL,
    WINTER
  }

  enum AdjudicationRates {
    HOUR,
    EIGHT_HOUR,
    TWELVE_HOUR,
    DAY,
    TWO_DAY,
    WEEK
  }

  enum OrderTypes {
    HOLD,
    MOVE,
    CONVOY,
    SUPPORT_MOVE,
    SUPPORT_HOLD
  }

  interface IGame {
    id: ID!
    name: String!
    description: String
    owner: User
    players: [Player!]!
    map: Map
    year: Int!
    season: Seasons!
    complete: Boolean
    nextAdjudication: Date
    isAutomaticAdjudicate: Boolean
    adjudicationRate: AdjudicationRates!
  }

  type Game implements IGame {
    id: ID!
    name: String!
    description: String
    owner: User
    players: [Player!]!
    map: Map
    year: Int!
    season: Seasons!
    complete: Boolean
    nextAdjudication: Date
    isAutomaticAdjudicate: Boolean
    adjudicationRate: AdjudicationRates!
  }

  type AdminGame implements IGame {
    id: ID!
    name: String!
    description: String
    owner: User
    players: [Player!]!
    map: Map
    year: Int!
    season: Seasons!
    complete: Boolean
    nextAdjudication: Date
    isAutomaticAdjudicate: Boolean
    adjudicationRate: AdjudicationRates!
    # admin exclusive fields
    playersWhoHaveSubmitted: [Player!]!
  }

  type Player {
    user: User!
    nickname: String
    nation: Nation
    numSupplyCenters: Int!
  }

  type Unit {
    type: UnitTypes!
    owner: Player
  }

  type Territory {
    definition: TerritoryDefinition!
    owner: Player
    occupyingUnit: Unit
  }

  type IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
  }

  type HoldOrder implements IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
  }

  type MoveOrder implements IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
    targetTerritory: Territory
  }

  type ConvoyOrder implements IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
    convoyTerritory: Territory
    targetTerritory: Territory
  }

  type SupportMoveOrder implements IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
    supportTerritory: Territory
    targetTerritory: Territory
  }

  type SupportHoldOrder implements IOrder {
    orderType: OrderTypes
    baseTerritory: Territory
    supportTerritory: Territory
  }

  union Order = HoldOrder | MoveOrder | ConvoyOrder | SupportMoveOrder | SupportHoldOrder

  ########
  # MAPS #
  ########

  enum TerritoryTypes {
    COASTAL,
    LAND,
    SEA
  }

  type Map {
    id: ID!
    name: String!
    nations: [Nation!]!
  }

  type Nation {
    name: String!
    color: Color!
    startingTerritories: [TerritoryDefinition!]!
  }

  type TerritoryDefinition {
    name: String!
    type: TerritoryTypes!
    shorthand: String!
    neighbors: [TerritoryDefinition!]!
    coasts: [TerritoryDefinition!]
    parentTerritory: TerritoryDefinition
    isSupplyCenter: Boolean
  }

  #########
  # QUERY #
  #########

  type Query {
    game(id: ID!): Game
    user(id: ID!): User
    map(id: ID!): Map
    maps: [Map]
  }

  ############
  # Mutation #
  ############

  input CreateUserInput {
    name: String!
    email: EmailAddress!
    password: String!
    passwordConfirmation: String!
  }

  type CreateUserPayload implements IRequest {
    success: Boolean!
    data: User
    error: ClientError
  }

  input LoginInput {
    email: String!
    password: String!
  }

  type LoginPayload implements IRequest {
    success: Boolean!
    data: String
    error: ClientError
  }

  type Mutation {
    createUser(input: CreateUserInput!): CreateUserPayload!
    login(input: LoginInput!): LoginPayload!
  }
`
