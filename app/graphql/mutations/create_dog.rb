# frozen_string_literal: true

module Mutations
  class CreateDog < BaseMutation
    argument :dog, Types::DogInput, required: true

    field :dog, Types::DogType, null: true

    def resolve(dog:)
      boot_unauthenticated_user

      new_dog = Dog.create!(
        user: context[:current_user],
        name: dog[:name],
        activity_level: dog[:activity_level],
        breed: dog[:breed],
        birthdate: dog[:birthdate],
        weight: dog[:weight],
        long_desc: dog[:long_desc],
        short_desc: dog[:short_desc]
      )

      { dog: new_dog }
    end
  end
end
