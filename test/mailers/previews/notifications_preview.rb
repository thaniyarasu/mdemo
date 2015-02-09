# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications/notify
  def notify
    Notifications.notify
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications/signup
  def signup
    Notifications.signup
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications/forgot_password
  def forgot_password
    Notifications.forgot_password
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications/invoice
  def invoice
    Notifications.invoice
  end

end
