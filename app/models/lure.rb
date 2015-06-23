class Lure < ActiveRecord::Base
	include ResourceWithName
	include Categorizable
	include Rails.application.routes.url_helpers

	belongs_to :brand

	def url
		polymorphic_path(self)
	end

	def as_json(options={})
    super(options.merge(:methods => [:title, :url], :only => []))
  end

  def title
  	brand ? "#{brand.name} #{name}" : name
  end
end
