class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work
  has_many :works

  validates :username, uniqueness: true, presence: true
  validates :uid, uniqueness: { scope: :provider }



  def self.build_from_oauth(auth_hash)
    user = User.new
    if auth_hash["provider"] == "github"
      user.username = auth_hash["info"]["nickname"]
    elsif auth_hash["provider"] == "google_auth2"
      user.username = auth_hash["info"]["name"]
    end
    user.uid = auth_hash["uid"]
    user.email = auth_hash["info"]["email"]
    user.provider = auth_hash["provider"]
    user.avatar = auth_hash["info"]["image"]
    return user
  end
end
