require 'rails_helper'

RSpec.describe Mutations::UpdateProject, type: :request do
  describe '.resolve' do
    let!(:project) { create(:project) }
    let(:query) do
      <<~GQL
        mutation {
          updateProject(input: { id: #{project.id}, title: "New project" }) {
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
          updateProject(input: { id: #{project.id}, title: "", }) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end

    it 'update a project' do
      post '/graphql', params: { query: query }
      json = JSON.parse(response.body)
      data = json['data']['updateProject']["project"]
      expect(data["title"]).to eq("New project")
    end

    it 'returns errors if the project is invalid' do
      post '/graphql', params: { query: query_without_title }

      json = JSON.parse(response.body)
      data = json['data']["updateProject"]

      expect(data['project']).to be_nil
      expect(data['errors']).to include("Title can't be blank")
    end
  end
end
