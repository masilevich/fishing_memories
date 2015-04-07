require "spec_helper"

def resource_name
	resource_class.model_name.name
end

def singular_resource_name
	resource_class.model_name.singular
end

def plural_resource_name
	resource_class.model_name.plural
end

def resource_label(resource_class = resource_class())
	resource_class.model_name.human count: 1,
	default: resource_class.to_s.gsub('::', ' ').titleize
end

def plural_resource_label(resource_class = resource_class(), options = {})
	defaults = {count: PLURAL_MANY_COUNT, default: resource_label.pluralize.titleize}
	resource_class.model_name.human defaults.merge options
end

def resource_path(resource)
	polymorphic_path([get_namespace, resource])
end

def new_resource_path
	new_polymorphic_path([get_namespace, resource_class])
end

def edit_resource_path(resource)
	edit_polymorphic_path([get_namespace, resource])
end

def resources_path
	polymorphic_path([get_namespace, plural_resource_name])
end

def get_namespace
	respond_to?(:namespace) ? namespace : nil
end
