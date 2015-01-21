shared_examples "table with related memories" do

	it "should have head" do
		expect(page).to have_selector('th', text: I18n.t("fishing_memories.related_memories"))
		expect(page).to have_selector('th', text: Memory.human_attribute_name("description"))
	end

	it "should have content and links" do
		memories.each do |memory|
			expect(page).to have_selector('td', text: memory.title)
			expect(page).to have_selector('td', text: memory.description.truncate(70))
			expect(page).to have_link(I18n.t('fishing_memories.show'), href: memory_path(memory))
			expect(page).to have_link(I18n.t('fishing_memories.edit'), href: edit_memory_path(memory))
			expect(page).to have_link(I18n.t('fishing_memories.delete'), href: memory_path(memory))
		end
	end

	it "should not have other memories" do
		other_memories.each do |memory|
			expect(page).to_not have_selector('td', text: memory.title)
			expect(page).to_not have_selector('td', text: memory.description.truncate(70))
		end
	end

end
