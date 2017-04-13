class TagTopic < ApplicationRecord
  validates :topic, presence: true, uniqueness: true

  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :topic_id,
    primary_key: :id
  )

  has_many(
    :urls,
    through: :taggings,
    source: :url
  )

  def popular_links
    # urls.group(:id).order(:num_clicks)
    # urls.map { |url| url.num_clicks }.sort
    urls.joins(:visits)
  end

  # SELECT
  #   taggings.url_id
  # FROM
  #   topics
  # JOIN
  #   taggings ON taggings.topic_id = topics.id
  # JOIN
  #   visits ON taggings.url_id = visits.url_id
  # WHERE
  #   topic.topic = ?
  # GROUP BY
  #   taggings.url_id
  # ORDER BY
  #   COUNT(*)
  # LIMIT
  #   5

end
