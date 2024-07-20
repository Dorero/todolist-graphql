module Mutations
  class CreateProject < BaseMutation
    argument :title, String, required: true

    field :project, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(title:, description: nil, status: 0)
      project = Project.new(title: title)

      if project.save
        {
          project: project,
          errors: []
        }
      else
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
