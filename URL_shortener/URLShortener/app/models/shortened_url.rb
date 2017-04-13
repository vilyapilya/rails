# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string
#  short_url    :string
#  submitter_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ShortenedUrl < ApplicationRecord

  validates :long_url, :submitter_id, presence: true
  validates :short_url, presence: true, uniqueness: true

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while  ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :user
  )

  def self.create!(user, long_url)
    code = random_code
    url = ShortenedUrl.new(submitter_id: user.id, long_url: long_url, short_url: code)
    url.save!
    url
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.select(:user_id).where(["created_at > ?", 10.minutes.ago]).distinct.count
  end

  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many(
    :tag_topics,
    through: :taggings,
    source: :topic
  )

end
