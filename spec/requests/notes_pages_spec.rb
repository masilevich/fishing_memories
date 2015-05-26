require 'spec_helper'
require 'user_helper'
require "requests/shared_examples/resource_pages"
require "requests/shared_examples/resource_with_name_pages"
require "requests/shared_examples/filter"

describe "NotesPages" do
	let(:resource_class) { Note }

	it_should_behave_like "resource pages" 

	it_should_behave_like "resource with name pages" 

	include_context "login user"

	describe "index" do

		let!(:notes) { FactoryGirl.create_list(:note, 2, user: user, tag_list: "tag1, tag2") }
		before {visit notes_path}

		describe "table" do

			it "should have header" do
				expect(page).to have_selector('th', text: Note.human_attribute_name("created_at"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("updated_at"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("text"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("tag_list"))
			end

			it "should have content" do
				notes.each do |note|
					expect(page).to have_selector('td', text: note.created_at.to_date)
					expect(page).to have_selector('td', text: note.updated_at.to_date )
					expect(page).to have_selector('td', text: note.text.truncate(70))
					note.tags.each { |tag| expect(page).to have_link tag.name, href: tag_notes_path(tag.name) }
				end
			end
		end

		describe "tags" do
		  let!(:note_with_tag) { FactoryGirl.create(:note, user: user, tag_list: "tag to select") }
		  before {visit tag_notes_path(note_with_tag.tags.first.name)}
		  it "should display only notes with selected tag" do
		  	expect(page).to have_selector('td', text: note_with_tag.name)
		  	notes.each { |note| expect(page).to_not have_selector('td', text: note.name) }
		  end
		end
	end

	describe "show" do
		let!(:note) { FactoryGirl.create(:note, user: user, text: "note text", tag_list: "tag1, tag2") }
		before {visit note_path(note)}

		describe "panels" do
		  specify do
				expect(page).to have_selector('div.panel h3', text: Note.human_attribute_name("text"))
			end
		end

		describe "tables" do
			it "should have head" do
				expect(page).to have_selector('th', text: Note.human_attribute_name("created_at"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("updated_at"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("tag_list"))
				expect(page).to have_selector('th', text: Note.human_attribute_name("text"))
			end

			it "should have body" do
				expect(page).to have_selector('td', text: note.created_at.to_date)
				expect(page).to have_selector('td', text: note.updated_at.to_date)
				expect(page).to have_selector('tr', text: note.text)
				note.tags.each { |tag| expect(page).to have_link tag.name, href: tag_notes_path(tag.name) }
			end
		end
	end

end