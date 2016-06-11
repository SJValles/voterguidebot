class GuidesController < ApplicationController
  before_filter :find_guide, except: [:create, :new, :index]
  before_filter :init_guide, only: [:create, :new]
  before_filter :guide_params, only: [:create, :update]
  before_filter :invite_params, only: :users

  def create
    @guide = Guide.new guide_params
    @guide.users << current_user

    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :new
    end
  end

  def index
    redirect_to root_path
  end

  def update
    @guide.update_attributes guide_params
    @guide.template_fields = field_params if field_params
    saved = @guide.save

    respond_to do |format|
      format.json { render status: saved ? 200 : 400, json: '' }
      format.html { redirect_to guide_path(@guide), notice: saved ? 'Guide saved!' : 'Could not save!' }
    end
  end

  def users
    user = User.invite(invite_params, @guide, current_user.first_name)
    render json: { state: user.valid? ? 'success' : 'error' }
  end

  private

  def field_params
    params.require(:guide).permit(fields: @guide.template_field_names)[:fields]
  end

  def guide_params
    params.require(:guide).permit(
        :name,
        :election_date,
        location_attributes: [:city, :state, :address, :lat, :lng,
                              :north, :south, :east, :west])
  end

  def invite_params
    params.require(:email)
  end

  def init_guide
    @guide = Guide.new
  end

  def find_guide
    @guide = Guide.find params[:id]
    return redirect_to guides_path unless current_user.can_edit?(@guide)
  end
end
