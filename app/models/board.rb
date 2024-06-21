class Board < ApplicationRecord
	before_create :set_original_seed
	
	private
	
	def set_original_seed
			self.original_seed = cells
	end
end