module Mutations
  class UpdateTask < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :status, String, required: false

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(id:, title:, description: nil, status: 0)
      task = Task.update(id, title: title, description: description, status: status)

      if task.valid?
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
