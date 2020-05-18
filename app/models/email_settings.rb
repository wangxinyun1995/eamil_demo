class EmailSettings < Settingslogic
  source "#{Rails.root}/config/email_settings.yml"
  namespace Rails.env
end