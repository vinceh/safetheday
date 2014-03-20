class Post < ActiveRecord::Base
  attr_accessible :body, :title, :hero_image, :thumbnail_image
end