require 'rails_helper'

RSpec.describe Mutations::DestroyProject, type: :request do
  describe '.resolve' do
    let!(:project) { create(:project) }
    let(:query) do
      <<~GQL
        mutation {
          destroyProject(input: { id: #{project.id} }) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end

    let(:query_with_invalid_id) do
      <<~GQL
        mutation {
          destroyProject(input: { id: -1 }) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end

    it 'destroy a project' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['destroyProject']["project"]
      expect(data["title"]).to eq(project.title)
      expect(Task.count).to eq(0)
    end

    it 'returns errors if the project not found' do
      post '/graphql', params: { query: query_with_invalid_id }

      json = JSON.parse(response.body)
      data = json['data']["destroyProject"]

      expect(data['task']).to be_nil
      expect(data['errors']).to include("Project not found")
    end
  end
end
