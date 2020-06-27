Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
    Rails.application.credentials.facebook_app_id,
    Rails.application.credentials.facebook_app_secret,
    scope: 'email, read_stream', display: 'popup'
end
