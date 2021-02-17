class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
end
