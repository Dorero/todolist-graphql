module Mutations
  class DestroyProject < BaseMutation
    argument :id, ID, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      project = Project.find_by(id: id)

      if project.nil?
        return {
          project: nil,
          errors: ["Project not found"]
        }
      end

      if project.destroy
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
