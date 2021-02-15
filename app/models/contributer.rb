class Contributer < ApplicationRecord
  has_many :infos
  has_many :projects, through: :infos
end
