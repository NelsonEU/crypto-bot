class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('alert_email_address')
  layout 'mailer'
end
