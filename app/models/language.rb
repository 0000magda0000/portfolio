class Language < ApplicationRecord
  has_many :projects
  has_many :skills
  has_many :projects, through: :skills
end
