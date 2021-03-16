class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('ALERT_EMAIL_ADRESS')
  layout 'mailer'
end
