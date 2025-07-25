class User < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  enum access_level: {user: 0, manager: 1, admin: 2}

  scope :by_name, ->(term) { where("name ILIKE ?", "%#{sanitize_sql_like(term)}%") }
  scope :by_email, ->(term) { where("email ILIKE ?", "%#{sanitize_sql_like(term)}%") }
end
