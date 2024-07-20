# spec/requests/graphql_spec.rb
require 'rails_helper'

RSpec.describe "Project", type: :request do
  describe "projects query" do
    let!(:task) { create(:task) }
    let!(:tasks) { create_list(:task, 2) }

    let(:query) do
      <<~GQL
        query($limit: Int, $offset: Int) {
          projects(limit: $limit, offset: $offset) {
            id
            title
            tasks {
              id 
              title
              description
            }     
          }
        }
      GQL
    end

    it "should returns projects" do
      post "/graphql", headers: { 'Content-Type' => 'application/json' }, params: { query: query }.to_json
      json = JSON.parse(response.body)
      data = json['data']['projects']

      expect(data.size).to eq(3)
      expect(data[0]['title']).to eq(task.project.title)
      expect(data[0]['tasks'].first["title"]).to eq(task.title)
      expect(data[0]['tasks'].first["description"]).to eq(task.description)
    end

    it "should returns only 2 projects" do
      post "/graphql", headers: { 'Content-Type' => 'application/json' }, params: { query: query, variables: { limit: 2 } }.to_json
      json = JSON.parse(response.body)
      data = json['data']['projects']

      expect(data.size).to eq(2)
    end
  end

  describe "project query" do
    let!(:task) { create(:task) }

    let(:query) do
      <<~GQL
        query($id: ID!) {
          project(id: $id) {
            id
            title
            tasks {
              id 
              title
              description
            }     
          }
        }
      GQL
    end

    it "should returns project" do
      post "/graphql", params: { query: query, variables: { id: task.project.id } }
      json = JSON.parse(response.body)
      data = json['data']['project']

      expect(data['title']).to eq(task.project.title)
      expect(data['tasks'].first["title"]).to eq(task.title)
      expect(data['tasks'].first["description"]).to eq(task.description)
    end

    it "should return not found" do
      post "/graphql", params: { query: query, variables: { id: -1 } }
      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq("Project not found")
    end
  end
end
