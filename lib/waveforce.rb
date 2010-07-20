module WaveForce
  VERSION = '0.0.1'
  APP_NAME = 'waveforce'

  def self.mapper(v)
    channel_en = [
      'nhk1','nhk2','ntv','tbs','fuji','asahi','tx'
    ]
    channel_ja = [
      'NHK総合','NHK教育','日本テレビ','TBSテレビ','フジテレビ','テレビ朝日','テレビ東京'
    ]
    if !channel_en.index(v).nil?
      channel_ja[channel_en.index(v)]
    elsif !channel_ja.index(v).nil?
      channel_en[channel_ja.index(v)]
    end
  end

  NOTIFY_TIMEOUT = 3
  DEFAULT_RESPONSE_BORDER = 100
  LEVEL_EMERGENCY = "★★★"
  LEVEL_IMPORTANT = "★★"
  LEVEL_WARNING   = "★"
end