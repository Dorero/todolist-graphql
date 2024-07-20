# spec/requests/graphql_spec.rb
require 'rails_helper'

RSpec.describe "Task", type: :request do
  describe "task query" do
    let!(:task) { create(:task) }
    let!(:tasks) { create_list(:task, 2) }

    let(:query) do
      <<~GQL
        query($limit: Int, $offset: Int) {
          tasks(limit: $limit, offset: $offset) {
            id
            title
            description  
          }
        }
      GQL
    end

    it "should returns tasks" do
      post "/graphql", headers: { 'Content-Type' => 'application/json' }, params: { query: query }.to_json
      json = JSON.parse(response.body)
      data = json['data']['tasks']

      expect(data.size).to eq(3)
    end

    it "should returns only 2 tasks" do
      post "/graphql", headers: { 'Content-Type' => 'application/json' }, params: { query: query, variables: { limit: 2 } }.to_json
      json = JSON.parse(response.body)
      data = json['data']['tasks']

      expect(data.size).to eq(2)
    end
  end

  describe "task query" do
    let!(:task) { create(:task) }

    let(:query) do
      <<~GQL
        query($id: ID!) {
          task(id: $id) {
            id
            title
            description  
          }
        }
      GQL
    end

    it "should returns task" do
      post "/graphql", params: { query: query, variables: { id: task.id } }
      json = JSON.parse(response.body)
      data = json['data']['task']

      expect(data['title']).to eq(task.title)
      expect(data['description']).to eq(task.description)
    end

    it "should return not found" do
      post "/graphql", params: { query: query, variables: { id: -1 } }
      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq("Task not found")
    end
  end
end
