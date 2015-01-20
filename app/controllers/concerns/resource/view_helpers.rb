module Resource
  module ViewHelpers

    def resource_path(resource)
      polymorphic_path(resource)
    end

    def new_resource_path
      new_polymorphic_path(resource_class)
    end

    def edit_resource_path(resource)
      edit_polymorphic_path(resource)
    end

    def resources_path
      polymorphic_path(plural_resource_name)
    end
    
  end
end