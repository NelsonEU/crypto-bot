class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('ALERT_EMAIL_ADDRESS')
  layout 'mailer'
end
