class NoticeMailer < ApplicationMailer
  def notice_email(email, notice)
    @notice = 'test_notice'
    mail(to: email, subject: '测试自动发邮件')
  end
end
