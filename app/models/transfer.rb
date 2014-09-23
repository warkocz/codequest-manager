class Transfer < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  validates :from, :to, presence: true

  monetize :amount_cents

  enum status: [:pending, :accepted, :rejected]
end