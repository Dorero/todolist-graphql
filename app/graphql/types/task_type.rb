class Types::TaskType < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
  field :description, String
  field :status, Int
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
