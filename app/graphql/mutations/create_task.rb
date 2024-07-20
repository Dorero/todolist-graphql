module Mutations
  class CreateTask < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :status, String, required: false
    argument :project_id, ID, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(title:, description: nil, status: 0, project_id:)
      task = Task.new(title: title, description: description, status: status, project_id: project_id)

      if task.save
        {
          task: task,
          errors: []
        }
      else
        {
          task: nil,
          errors: task.errors.full_messages
        }
      end
    end
  end
end
