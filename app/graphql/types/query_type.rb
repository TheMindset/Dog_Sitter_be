# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false,
                                     description: 'Returns a list of users'

    def users
      User.all
    end

    field :user, Types::UserType, null: false,
                                  description: 'Find user by ID' do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end

    field :dogs, [Types::DogType], null: false,
                                   description: 'Returns a list of dogs, or filtered dogs by attributes' do
      argument :age_range, [Int], required: false
      argument :activity_level_range, [Int], required: false
      argument :breed, [String], required: false
    end

    def dogs(**attributes)
      if attributes[:age_range]
        raise GraphQL::ExecutionError, 'Must provide an array with two integers' unless attributes[:age_range].count == 2

        one_year = 1.year.seconds
        beginnig_date = Time.zone.now - (attributes[:age_range].max * one_year) - one_year
        end_date = Time.zone.now - (attributes[:age_range].min * one_year)

        attributes[:birthdate] = beginnig_date..end_date
        attributes.delete(:age_range)
      end

      if attributes[:activity_level_range]
        raise GraphQL::ExecutionError, "Must provide an array with two integers" unless attributes[:activity_level_range].count == 2

        attributes[:activity_level_range] = attributes[:activity_level_range].min..attributes[:activity_level_range].max
        attributes.delete(:activity_level_range)
      end

      if attributes[:weight_range]
        raise GraphQL::ExecutionError, "Must provide an array with two integers" unless attributes[:weight_range].count == 2

        attributes[:weight_range] = attributes[:weight_range].min..attributes[:weight_range].max
        attributes.delete(:weight_range)
      end

      Dog.where(attributes)
    end

    field :dog, Types::DogType, null: false,
                                description: 'Find dog by ID' do
      argument :id, ID, required: true
    end

    def dog(id:)
      Dog.find(id)
    end
  end
end
