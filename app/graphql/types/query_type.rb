# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :projects, [Types::ProjectType], null: false do
      argument :limit, Int, required: false, default_value: 10
      argument :offset, Int, required: false, default_value: 0
    end
    field :project, Types::ProjectType, null: false do
      argument :id, ID, required: true
    end
    field :task, Types::TaskType, null: false do
      argument :id, ID, required: true
    end
    field :tasks, [Types::TaskType], null: false do
      argument :limit, Int, required: false, default_value: 10
      argument :offset, Int, required: false, default_value: 0
    end

    def project(id:)
      raise GraphQL::ExecutionError.new("Project not found", options: { status: :not_found })  unless Project.exists?(id)

      Project.find(id)
    end

    def projects(limit:, offset:)
      Project.limit(limit).offset(offset)
    end

    def task(id:)
      raise GraphQL::ExecutionError.new("Task not found", options: { status: :not_found })  unless Task.exists?(id)

      Task.find(id)
    end

    def tasks(limit:, offset:)
      Task.limit(limit).offset(offset)
    end
  end
end
