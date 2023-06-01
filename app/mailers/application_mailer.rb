class ApplicationMailer < ActionMailer::Base
  default from: %("#{I18n.t('general.app_title')}" <#{Rails.application.credentials.mailer[:from_email]}>)
  layout 'mailer'
end
