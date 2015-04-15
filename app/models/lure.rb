class Lure < ActiveRecord::Base
	include ResourceWithName
	include Categorizable
	include Rails.application.routes.url_helpers

	def url
		polymorphic_path(self)
	end

	def as_json(options={})
    super(options.merge(:methods => [:title, :url], :only => []))
  end
end
