class UserMailer < ApplicationMailer
  default from: 'simultation@example.com' ##must change before shipping to prod

  def conversation_complete_notification(user_email, conversation)
    @conversation = conversation
    mail(to: user_email, subject: 'Your conversation simulation is complete!')
  end
end
