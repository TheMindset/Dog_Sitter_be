# frozen_string_literal: true

class DogSitterBeSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
