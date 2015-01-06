module ApplicationHelper
	USER_NAME_REGEX =  /(?<user_name>[a-z]_?(?:[a-z0-9]_?)*)/

	def full_title(page_title="")
		base_title = I18n.translate('fishing_memories.title')
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	def resource_title
		case action_name
		when "new", "edit", "destroy"
			I18n.t("fishing_memories.#{action_name}_model", model: resource_label)
		when "index"
			plural_resource_label
		end
	end

	def resolve_body_class
		body_class = user_signed_in? ? "logged_in" : "logged_out"
		devise_controller? ? body_class + " devise" : body_class		
	end

end
