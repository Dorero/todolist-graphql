require 'rails_helper'

RSpec.describe Mutations::DestroyTask, type: :request do
  describe '.resolve' do
    let!(:task) { create(:task) }
    let(:query) do
      <<~GQL
        mutation {
          destroyTask(input: { id: #{task.id} }) {
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

    let(:query_with_invalid_id) do
      <<~GQL
        mutation {
          destroyTask(input: { id: -1 }) {
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

    it 'destroy a task' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['destroyTask']["task"]
      expect(data["title"]).to eq(task.title)
      expect(data["description"]).to eq(task.description)
      expect(Task.count).to eq(0)
    end

    it 'returns errors if the task not found' do
      post '/graphql', params: { query: query_with_invalid_id }

      json = JSON.parse(response.body)
      data = json['data']["destroyTask"]

      expect(data['task']).to be_nil
      expect(data['errors']).to include("Task not found")
    end
  end
end
