class Book < ApplicationRecord
  has_one_attached :book
  has_one_attached :cover
end
