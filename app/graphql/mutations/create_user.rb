# frozen_string_literal: true

# module Mutations
#   class CreateUser < BaseMutation
#     # TODO: define return fields
#     field :user, Types::UserType, null: true
#     field :errors, [String], null: false

#     # TODO: define arguments
#     argument :first_name, String, required: true
#     argument :last_name, String, required: true
#     argument :email, String, required: true
#     argument :short_desc, String, required: false
#     argument :long_desc, String, required: false

#     # TODO: define resolve method
#     # def resolve(first_name:, last_name:,email:, short_desc: nil, long_desc: nil)
#     #   User.create!(
#     #     first_name: first_name
#     #     last_name: last_name
#     #     email: email
#     #     short_desc: short_desc
#     #     long_desc: long_desc
#     #   )
#     # end

#     # SHORT HAND
#     def resolve(**attributes)
#       user = User.new(attributes)
#       if user.save
#         { user: user }
#       else
#         { errors: user.errors.full_message }
#       end
#     end
#   end
# end
