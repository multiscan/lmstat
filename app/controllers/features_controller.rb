class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show, :edit, :update, :toggle_visible]

  def index
    @features = Feature.by_used
  end

  def show
    ti_params = {dt: 604800, tb: Time.zone.now}.merge params.permit([:t, :ta, :tb, :dt])
    puts "ti_params: #{ti_params.inspect}"
    @ti = TimeInterval.new(ti_params)
    @period_usages = @feature.usages.open_between(@ti.ta, @ti.tb)
    @period_tokens = @feature.tokens.open_between(@ti.ta, @ti.tb)
    @usages = @period_usages.order('start_at DESC').limit(50)
    @tokens = @period_tokens.order('start_at DESC').limit(50)

    @token_average_duration = 0
    @token_average_duration_period = 0

    if @feature.tokens.count > 0
      @token_average_duration = @feature.tokens.closed.sum(:duration) / @feature.tokens.closed.count
    end
    if @period_tokens.count > 0
      @token_average_duration_period = @period_tokens.closed.sum(:duration) / @period_tokens.closed.count
    end

    @usage_ave = @feature.usage
    @used_max = @feature.used
    @usage_ave_period = 0
    @used_max_period = 0

    if @feature.usages.count > 0
      @usage_ave = @feature.usages.sum(:wu).to_f / @feature.usages.sum(:duration)
      @used_max =  @feature.usages.maximum(:used)
    end
    if @period_usages.count > 0
      @usage_ave_period = @period_usages.sum(:wu).to_f / @period_usages.sum(:duration)
      @used_max_period =  @period_usages.maximum(:used)
      @plot_data = @period_usages.map{|u| [u.from_ms, u.percent]}
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
