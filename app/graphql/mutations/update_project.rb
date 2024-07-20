module Mutations
  class UpdateProject < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(id:, title:)
      project = Project.update(id, title: title)

      if project.valid?
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
