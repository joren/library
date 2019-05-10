class Book < ApplicationRecord
  has_one_attached :book
  has_many_attached :images
end
