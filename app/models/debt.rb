class Debt < ActiveRecord::Base
  validates :amount, presence: true
  validates :description, presence: true
  validates :collector, presence: true
  validates :loaner, presence: true

  belongs_to :collector, :class_name => 'User'
  belongs_to :loaner, :class_name => 'User'

  after_initialize :defaults

  def defaults
      self.uuid ||= SecureRandom.uuid
  end
end
