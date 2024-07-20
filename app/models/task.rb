class Task < ApplicationRecord
  belongs_to :project
  enum :status, [ :not_done, :done]

  validates_presence_of :title
end
