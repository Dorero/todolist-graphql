require 'rails_helper'

RSpec.describe Mutations::UpdateTask, type: :request do
  describe '.resolve' do
    let!(:task) { create(:task) }
    let(:query) do
      <<~GQL
        mutation {
          updateTask(input: { id: #{task.id}, title: "New Task", description: "Task description" }) {
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
          updateTask(input: { id: #{task.id}, title: "", }) {
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

    it 'update a task' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['updateTask']["task"]
      expect(data["title"]).to eq("New Task")
      expect(data["description"]).to eq("Task description")
      expect(Task.count).to eq(1)
    end

    it 'returns errors if the task is invalid' do
      post '/graphql', params: { query: query_without_title }

      json = JSON.parse(response.body)
      data = json['data']["updateTask"]

      expect(data['task']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
    end
  end
end
