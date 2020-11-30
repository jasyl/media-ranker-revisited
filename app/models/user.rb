class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work

  validates :username, uniqueness: true, presence: true
  validates :uid, uniqueness: { scope: :provider }



  def self.build_from_oauth(auth_hash)
    user = User.new
    user.uid = auth_hash["uid"]
    user.username = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    user.provider = auth_hash["provider"]
    user.avatar = auth_hash["info"]["image"]
    return user
  end
end
