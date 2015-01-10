class ApiKey < ActiveRecord::Base
  validates :description, presence: true

  after_initialize :generate_secret

  def generate_secret
    self.access_token ||= SecureRandom.hex 24
  end
end
