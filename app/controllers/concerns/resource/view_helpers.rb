module Resource
  module ViewHelpers

    def resource_path(resource)
      admin_namespace? ? polymorphic_path([:admin, resource]) : polymorphic_path(resource)
    end

    def new_resource_path
      admin_namespace? ? new_polymorphic_path([:admin, resource_class]) : new_polymorphic_path(resource_class)
    end

    def edit_resource_path(resource)
      admin_namespace? ? edit_polymorphic_path([:admin, resource]) : edit_polymorphic_path(resource)
    end

    def resources_path
      admin_namespace? ? polymorphic_path([:admin, plural_resource_name]) : polymorphic_path(plural_resource_name)
    end

    def admin_namespace?
      controller_path.split('/').first == 'admin'
    end

  end
end