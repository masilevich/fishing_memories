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
		body_class = user_signed_in? ? "logged_in" : "logged_out"
		devise_controller? ? body_class + " devise" : body_class		
	end

	# Returns an array of links to use in a breadcrumb
	def breadcrumb_links(path = request.path)
  	# remove leading "/" and split up the URL
    # and remove last since it's used as the page title
    parts = path.split('/').select(&:present?)[0..-2]

    parts.each_with_index.map do |part, index|
	    if part =~ /\A(\d+|[a-f0-9]{24})\z/ && parts[index-1]
	    	name   = find_resource.title
	    end
	    name ||= I18n.t "activerecord.models.#{part.singularize}", count: PLURAL_MANY_COUNT, default: part.titlecase
	    link_to name, url_for('/' + parts[0..index].join('/'))
	  end
	end

	def clear_text_from_tags(text)
		strip_tags(text.gsub("&nbsp;", "").gsub("&#39;", "'"))
	end

end
