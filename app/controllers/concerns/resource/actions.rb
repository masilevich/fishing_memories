module Resource
	module Actions
		
		def new
			@resource = resources.build()
		end

		def create
			@resource = resources.build(resource_params)
			if @resource.save
				flash[:notice] = t('fishing_memories.model_created', model: resource_label)
				redirect_to resources_path
			else
				flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
				render 'new'
			end
		end

		def edit
		end

		def update
			if @resource.update_attributes(resource_params)
				flash[:notice] = t('fishing_memories.model_updated', model: resource_label)
				redirect_to resources_path
			else
				flash.now[:alert] = t('fishing_memories.model_not_updated', model: resource_label)
				render 'edit'
			end
		end

		def index
			@resources = sort_column ? resources.unscoped.order(sort_column + ' ' + sort_direction) : resources 
			@resources = @resources.page(params[:page])
		end

		def destroy
			delete_result = find_resource.destroy
			success_flash = t('fishing_memories.model_destroyed', model: resource_label)
			fail_flash = t('fishing_memories.model_not_destroyed', model: resource_label)
			@resources = resources.page(params[:page]) if delete_result
			respond_to do |format|
				format.html do
					if delete_result
						flash[:notice] = success_flash
						redirect_to resources_path
					else
						flash[:alert] = fail_flash
					end
				end
				format.js do
					if delete_result
						flash[:notice] = success_flash
					else
						flash[:alert] = fail_flash
					end
				end
			end
		end

		def show
		end
	end
end