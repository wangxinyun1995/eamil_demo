class ApplicationMailer < ActionMailer::Base
  default from: EmailSettings.email.user_name
  layout 'mailer'
end
