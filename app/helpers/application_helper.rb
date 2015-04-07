module ApplicationHelper

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

	def breadcrumb_links(path = request.path)

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

  def map_and_join(items, column_name, separator = ', ')
  	items.map(&column_name).join(separator)
  end

  def nav_link(link_text, link_path, resource_name = nil, &block)
  	class_name = (resource_name.kind_of?(Array) ? 
      resource_name.include?(controller_name) : controller_name == resource_name) ? 
    'current' : ''
    class_name = "has_nested #{class_name}" if block
    
    content_tag(:li, :class => class_name, id: resource_name) do
      concat(link_to link_text, link_path)
      if block
        concat(content_tag(:ul, capture(&block)))
      end
    end
  end

  def sortable_col(column, title = nil)
    css_class = (column == sort_column) ? "sorted-#{sort_direction}" : nil
    content_tag(:th, class: "sortable col #{css_class}") do
      if title
        sort_link(@q, column, title, hide_indicator: true)
      else
        sort_link(@q, column, hide_indicator: true)
      end
    end
  end

  def static_pages_controller?
    controller_name == "static_pages"
  end

  def show_sidebar?
    action_name == "index"
  end

  def admin_namespace?
    controller.class.name.split("::").first=="Admin"
  end

end
