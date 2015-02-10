module CategorizableResource
	extend ActiveSupport::Concern

	included do
    before_action :set_categories, only: [:new, :edit, :index]
  end

  private

  def set_categories
    @categories = current_user.send("#{singular_resource_name}_categories")
  end

end