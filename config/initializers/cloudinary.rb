Cloudinary.config do |config|
  config.cloud_name = Rails.application.credentials.cloudinary[:cloud_name].dump
  config.api_key = Rails.application.credentials.cloudinary[:api_key].dump
  config.api_secret =  Rails.application.credentials.cloudinary[:api_secret].dump
  config.secure = true
  config.cdn_subdomain = true
end
