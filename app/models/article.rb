class Article < ApplicationRecord
	acts_as_taggable 
	validates :question, length: { minimum: 5 }
	validates :answer, length: { minimum: 1 }
end
