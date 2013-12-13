class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :toggle_visible]

  def index
    @features = Feature.by_used
  end

  def show
    @usages = @feature.usages.order('updated_at DESC').limit(50)
    @tokens = @feature.tokens.order('start_at DESC').limit(50)
    if @tokens.count > 0
      @token_average_duration = @feature.tokens.closed.sum(:duration) / @feature.tokens.closed.count
    else
      @token_average_duration = 0
    end
    if @usages.count > 0
      @usage_ave = @feature.usages.sum(:wu).to_f / @feature.usages.sum(:duration)
      @used_max =  @feature.usages.maximum(:used)
      # @total_min = @feature.usages.minimum(:total)
      # @total_max = @feature.usages.maximum(:total)
      @plot_data = @feature.usages.map{|u| [u.from_ms, u.percent]}
    else
      @usage_ave = @feature.usage
      @used_max  = @feature.used
    end
  end

  def edit
    @feature.custom_color=@feature.color unless @feature.custom_color.present?
    respond_to do |format|
      format.html
      format.js
    end
  end

  # def toggle_visible
  #   respond_to do |format|
  #     if @feature.update({visible: !@feature.visible})
  #       format.html { redirect_to features_path, notice: 'Feature was successfully updated.'}
  #       format.js
  #     else
  #       format.html { redirect_to features_path, notice: 'Something wrong in toggling feature visibility.'}
  #       format.js   { render action: 'edit' }
  #     end
  #   end
  # end

  def update
    # authorize! :update, @feature
    p=params.require(:feature).permit(:custom_color, :nick, :visible)
    respond_to do |format|
      if @feature.update(p)
        format.html { redirect_to features_path, notice: 'Feature was successfully updated.'}
        format.js
      else
        format.html { render action: 'edit'}
        format.js { render action: 'edit'}
      end
    end
  end

 private

  def set_feature
    @feature = Feature.find(params[:id])
    # authorize! :read, @feature
  end


end
