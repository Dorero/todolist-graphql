module Mutations
  class DestroyTask < BaseMutation
    argument :id, ID, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(id:)
      task = Task.find_by(id: id)

      if task.nil?
        return {
          task: nil,
          errors: ["Task not found"]
        }
      end

      if task.destroy
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
