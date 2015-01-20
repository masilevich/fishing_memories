class Tackle < ActiveRecord::Base
	include ResourceWithName

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackle_sets

	 def memories_with_tackle_sets_memories
    joins(:tackle_sets).joins(:memories)
    #memories.joins(:products).where(:products => {:brand_id => 1})
    #memories.joins("join pages_paragraphs on pages.id = pages_paragraphs.page_id").where(["pages_paragraphs.paragraph_id = ?", paragraph_id])
  end
end
