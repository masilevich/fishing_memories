module Brandable
	extend ActiveSupport::Concern

	included do
    before_action :set_brands, only: [:new, :edit, :index]
  end

  private

  def set_brands
		@brands = current_user.brands
	end

end