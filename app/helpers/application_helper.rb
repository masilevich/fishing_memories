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

	def resolve_body_class
		if user_signed_in?
			"logged_in"
		else
			if devise_controller?
				"logged_out devise"
			else
				"logged_out"
			end
		end
	end
end
