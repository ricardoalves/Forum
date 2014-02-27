module Subscribem
  class Account < ActiveRecord::Base
  	EXCLUDED_SUBDOMAINS = %w(admin)
  	UNALLOWED_SUBDOMAIN_ERROR = "Subdomain is not allowed. Please choose another \
  														 subdomain."
  	INVALID_SUBDOMAIN_FORMAT_ERROR = "is not allowed. Please choose another \
  																		subdomain."

  	before_validation { self.subdomain = subdomain.to_s.downcase }
  	validates :subdomain, presence: true, uniqueness: true
  	validates :subdomain, exclusion: { in: EXCLUDED_SUBDOMAINS, 
  																		 message: UNALLOWED_SUBDOMAIN_ERROR }
  	validates :subdomain, format: { with: /\A[\w\-]+\Z/i, 
  																	message: INVALID_SUBDOMAIN_FORMAT_ERROR }

  	belongs_to :owner, class_name: "Subscribem::User"
    has_many :members, class_name: "Subscribem::Member"
    has_many :users, through: :members

  	accepts_nested_attributes_for :owner

    def self.create_with_owner( params = {} )
      account = new( params )
      if account.save
        account.users << account.owner
      end
      account
    end
  end
end
