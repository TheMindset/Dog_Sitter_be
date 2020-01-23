# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users,
          [Types::UserType],
          null: false,
          description: 'Returns a list of users'

    def users
      User.all
    end

    field :user,
          Types::UserType,
          null: false,
          description: 'Find user by ID' do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end

    field :current_user, 
      Types::CurrentUserType, 
      null: true
      description: 'Get information about the current_user'

    def current_user
      context[:current_user]
    end

    field :dogs,
          [Types::DogType],
          null: false,
          description: 'Returns a list of dogs, or filtered dogs by attributes' do
      argument :age_range, [Int], required: false
      argument :activity_level_range, [Int], required: false
      argument :breed, [String], required: false
      argument :weight_range, [Int], required: false
    end

    def dogs(**attributes)
      raise GraphQL::ExecutionError, 'Must provide an array with two integers' if attributes[:age_range] && attributes[:age_range].count != 2
      raise GraphQL::ExecutionError, "Must provide an array with two integers" if attributes[:activity_level_range] && attributes[:activity_level_range].count != 2
      raise GraphQL::ExecutionError, "Must provide an array with two integers" if attributes[:weight_range] && attributes[:weight_range].count != 2

      if attributes[:weight_range]
        attributes[:weight] = [attributes[:weight_range].min..attributes[:weight_range].max]
        attributes.delete(:weight_range)
      end

      if attributes[:activity_level_range]
        attributes[:activity_level] = [attributes[:activity_level_range].min..attributes[:activity_level_range].max]
        attributes.delete(:activity_level_range)
      end

      if attributes[:age_range]
        one_year = 1.year.seconds
        beginnig_date = Time.zone.now - (attributes[:age_range].max * one_year) - one_year
        end_date = Time.zone.now - (attributes[:age_range].min * one_year)
        attributes[:birthdate] = [beginnig_date..end_date]
        attributes.delete(:age_range)
      end

      Dog.order(:id).where(attributes)
    end

    field :dog,
          Types::DogType,
          null: false,
          description: 'Find dog by ID' do
      argument :id, ID, required: true
    end

    def dog(id:)
      Dog.find(id)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end

    field :locations,
          [Types::LocationType],
          null: false,
          description: "Return a list of locations"

    def locations
      Location.all
    end
  end
end
