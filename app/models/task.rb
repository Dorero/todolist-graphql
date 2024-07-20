class Task < ApplicationRecord
  belongs_to :project
  enum :status, [ :not_done, :done]
end
