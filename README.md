## Setup
```
git clone git@github.com:Dorero/todolist-graphql.git && cd todolist-graphql && bundle install
docker compose up -d && rails db:create && rails db:migrate 
```
## Test
```
rails db:seed
bundle exec rspec
```
