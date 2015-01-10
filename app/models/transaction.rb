class Transaction < ActiveRecord::Base
  validates :balance, presence: true
  validates :description, presence: true
  validates :sender, presence: true
  validates :recipient, presence: true

  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'

  after_initialize :defaults

  def defaults
      self.uuid ||= SecureRandom.uuid
  end
end
