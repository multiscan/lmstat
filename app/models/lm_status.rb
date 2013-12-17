class LmStatus

  # attr_accessor :time, :features, :logfile

  def initialize(params)
    @valid=false

    # set mandatory timestamp either from explicit parameter or from filename
    ts = params[:time]
    if ts.nil? &&
      f = if p=params[:file]
            p.original_filename
          elsif p=params[:logpath]
            File.basename(p)
          else
            nil
          end
      if f && f =~ /([0-9]{10}).log$/
        ts = f[0..9]
      end
    end
    return if ts.nil?
    @timestamp = Time.at(ts.to_i)

    # set feature either from json parameter or by parsing the attached file
    if f=params[:features]
      @features = feat
    else
      if f=params[:file]
        p=LmstatParser.new(f.tempfile)
        @features = p.features
      elsif f=params[:logpath]
        p=LmstatParser.new(f)
        @features = p.features
      else
        return
      end
    end

    # if we reach this point all mandatory parameters (@timestamp and @features) are set
    @valid=true

  end

  def save
    return false unless @valid
    @features.each do  |f|
      Feature.import(f,@timestamp)
    end
  end
end
