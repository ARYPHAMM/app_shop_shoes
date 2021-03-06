class Category < ApplicationRecord

  #associates
  has_many :products
  has_many :brands
  enum status: [:closed, :archived,:active]
  #validate
  validates :name, presence:true, length: {minimum: 3, maximum: 30}, uniqueness:true
  # validates :description, presence:true, length: {minimum: 3, maximum: 200}, uniqueness:true
end
