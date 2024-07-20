require 'rails_helper'

RSpec.describe Mutations::CreateTask, type: :request do
  describe '.resolve' do
    let!(:project) { create(:project) }

    let(:query) do
      <<~GQL
        mutation {
          createTask(input: { title: "New Task", description: "Task description", projectId: #{project.id} }) {
            task {
              id
              title
              description
            }
            errors
          }
        }
      GQL
    end

    let(:query_without_title) do
      <<~GQL
        mutation {
          createTask(input: { title: "", projectId: #{project.id}  }) {
            task {
              id
              title
              description
            }
            errors
          }
        }
      GQL
    end

    it 'creates a task' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['createTask']["task"]
      expect(data["title"]).to eq("New Task")
      expect(data["description"]).to eq("Task description")
      expect(Task.count).to eq(1)
    end

    it 'returns errors if the task is invalid' do
      post '/graphql', params: { query: query_without_title }

      json = JSON.parse(response.body)
      data = json['data']["createTask"]

      expect(data['task']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
      expect(Task.count).to eq(0)
    end
  end
end
