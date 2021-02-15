class Project < ApplicationRecord
  has_many :languages
  has_many :skills
  has_many :languages, through: :skills
  has_many :infos
  has_many :contributers, through: :infos
  has_one_attached :photo
end
