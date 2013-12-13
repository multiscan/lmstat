class TokensController < ApplicationController
  def index
    @ti = TimeInterval.new(params.permit([:t, :ta, :tb, :dt]))
    base_query = Token.open_between(@ti.ta, @ti.tb)
    # base_query =
    #   if ti.given?
    #     if ti.dt==0
    #       Token.open_at(ti.t)
    #     else
    #       Token.open_between(ti.ta, ti.tb)
    #     end
    #   else
    #     Token.order('start_at DESC')
    #   end
    if params[:feature_id].present?
      @all_features = false
      base_query = base_query.where(feature_id: params[:feature_id])
    else
      @all_features = params[:all].present?
      unless @all_features
        base_query = base_query.includes(:feature).where(["features.visible = ?", true]).references(:features)
      end
    end
    @tokens = base_query.includes(:user, :workstation, :feature).paginate(:page=>params[:page], :per_page=>100)

    @plot_data=[]
    @plot_ta = @ti.ta_ms
    @plot_tb = @ti.tb_ms
    plottable_tokens=base_query.order("slot ASC").order("feature_id ASC")
    lsid=0    # last slot id
    plottable_tokens.each do |t|
      fid=t.feature_id
      sid=1000*fid+(t.slot||0)
      if sid!=lsid
        @plot_data << {name: "#{t.feature.name} / #{t.slot}", color: t.color, data: []}
        lsid=sid
      end
      @plot_data.last[:data] << [0, t.start_ms, t.stop_ms]
    end
  end

  # def plot
  #   from=params[:from_date]||3.day.ago
  #   range=params[:range]||86400
  #   to=from + range.seconds
  #   tokens=Token.where(['start BETWEEN ? AND ? OR stop BETWEEN ? AND ?', from, to, from, to]).order("slot ASC").order("feature_id ASC")
  #   lid=0
  #   nid=-1
  #   @plot_categories=[]
  #   @plot_data=tokens.map do |t|
  #     Rails.logger.debug t
  #     id=1000*t.feature_id+(t.slot||0)
  #     if id!=lid
  #       nid=nid+1
  #       lid=id
  #       @plot_categories << "#{t.feature.shortname}/#{t.slot}"
  #     end
  #     [nid, t.start_ms, t.stop_ms]
  #   end
  # end

  # def plot
  #   from=params[:from_date]||3.day.ago
  #   range=params[:range]||86400
  #   to=from + range.seconds
  #   tokens=Token.where(['start BETWEEN ? AND ? OR stop BETWEEN ? AND ?', from, to, from, to]).order("slot ASC").order("feature_id ASC")
  #   yslot=-1  # progressive Y axis slot id
  #   lsid=0    # last slot id
  #   lfid=0    # last feature id
  #   @plot_categories=[]
  #   @plot_data=[]
  #   tokens.each do |t|
  #     Rails.logger.debug t
  #     fid=t.feature_id
  #     sid=1000*fid+(t.slot||0)
  #     if fid != lfid
  #       @plot_data << {name: t.feature.name, data: []}
  #       lfid = fid
  #     end
  #     if sid!=lsid
  #       yslot=yslot+1
  #       lsid=sid
  #       @plot_categories << t.slot.to_s
  #     end
  #     @plot_data.last[:data] << [yslot, t.start_ms, t.stop_ms]
  #   end
  # end

  # def plot
  #   from=params[:from_date]||3.day.ago
  #   range=params[:range]||86400
  #   to=from + range.seconds
  #   tokens=Token.where(['start BETWEEN ? AND ? OR stop BETWEEN ? AND ?', from, to, from, to]).order("slot ASC").order("feature_id ASC")
  #   lfid=0    # last feature id
  #   @plot_data=[]
  #   tokens.each do |t|
  #     Rails.logger.debug t
  #     fid=t.feature_id
  #     if fid != lfid
  #       @plot_data << {name: t.feature.name, data: []}
  #       lfid = fid
  #     end
  #     @plot_data.last[:data] << [(t.slot||1)-1, t.start_ms, t.stop_ms]
  #   end
  # end

end
