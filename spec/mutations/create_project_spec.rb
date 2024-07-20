require 'rails_helper'

RSpec.describe Mutations::CreateProject, type: :request do
  describe '.resolve' do
    let(:query) do
      <<~GQL
        mutation {
          createProject(input: { title: "New project" }) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end

    let(:query_without_title) do
      <<~GQL
        mutation {
          createProject(input: { title: "" }) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end

    it 'creates a project' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['createProject']["project"]
      expect(data["title"]).to eq("New project")
      expect(Project.count).to eq(1)
    end

    it 'returns errors if the project is invalid' do
      post '/graphql', params: { query: query_without_title }

      json = JSON.parse(response.body)
      data = json['data']["createProject"]

      expect(data['project']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
      expect(Task.count).to eq(0)
    end
  end
end
