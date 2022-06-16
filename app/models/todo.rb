class Todo < ApplicationRecord
  belongs_to :user, foreign_key: :created_by, optional: true
  has_many :items, dependent: :destroy

  validates_presence_of :title, :created_by
end
