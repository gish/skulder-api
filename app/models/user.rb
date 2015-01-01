class User < ActiveRecord::Base
    validates :given_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true

    has_many :expenses, :class_name => 'Debt', :foreign_key => 'collector_id', :inverse_of => :collector, :dependent => :delete_all
    has_many :debts, :class_name => 'Debt', :foreign_key => 'loaner_id', :inverse_of => :loaner, :dependent => :delete_all

    after_initialize :defaults

    def defaults
        self.uuid ||= SecureRandom.uuid
        self.secret ||= SecureRandom.uuid
    end

    def as_json
      super(
        :except => [:id, :secret]
      )

    end
end
