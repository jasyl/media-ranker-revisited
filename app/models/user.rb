class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work

  validates :username, uniqueness: true, presence: true


  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.username = auth_hash[:info][:nickname]
    user.email = auth_hash[:info][:email]
    user.provider = "github"
    return user
  end
end
