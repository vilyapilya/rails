class Visit < ApplicationRecord
  validates :user_id, :url_id, presence: true

  def self.record_visit!(user, shortened_url)
    visit = Visit.new(user_id: user.id, url_id: shortened_url.id)
    visit.save!
    visit
  end

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :url,
    class_name: "ShortenedUrl",
    foreign_key: :url_id,
    primary_key: :id
  )

end
