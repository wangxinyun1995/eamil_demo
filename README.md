#### 第一步, `rails new email_demo`,建立一个新项目
#### 第二部, `rails generate mailer NoticeMailer`, 创建邮件程序
```
# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"  # 你发送邮件所使用的账号,用163邮箱为例
  layout 'mailer'
end
 
# app/mailers/notice_mailer.rb
class NoticeMailer < ApplicationMailer
end
```
开通163邮箱的smtp功能;
`http://help.163.com/10/0312/13/61J0LI3200752CLQ.html`
记住所展示的秘钥,163只展示一次,可拍照记录

#### 我们定义一个名为 notice_email 的方法,发送一封邮件
```
# app/mailers/notice_mailer.rb
class NoticeMailer < ApplicationMailer
  def notice_email(email, notice)
    @notice = 'test_notice'
    mail(to: email, subject: '测试自动发邮件')
  end
end
```
#####  创建邮件视图
在 app/views/notice_mailer/ 文件夹中新建文件 notice_email.html.erb。这个视图是邮件的模板，使用 HTML 编写：
```

<!DOCTYPE html>
<html>
  <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
  </head>
  <body>
    <h1>Welcome to example.com, <%= @notice %></h1>
    <p>
      You have successfully signed up to example.com,
      your username is: <%= @notice %>.<br>
    </p>
    <p>
      To login to the site, just follow this link: <%= @url %>.
    </p>
    <p>Thanks for joining and have a great day!</p>
  </body>
</html>
```

#### 配置邮箱信息
```
# config/environments/development.rb
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.163.com',
    port:                  465,
    domain:               '163.com',
    user_name:            'your_email_name' # 你的邮箱账户
    password:             'your_email_secret' # 邮箱秘钥,注意不是邮箱密码,是上面开通smtp功能提供的密钥
    authentication:       :plain,
    enable_starttls_auto: true,
    ssl: true
  }
```
本地可以使用25端口,但是阿里云服务器禁用了25端口,我们才用了465端口
#### 测试发邮件
```
# 进入 rails c
 NoticeMailer.notice_email('329414837@qq.com', '123').deliver_now
```
#### email的账号和密码放入配置文件中处理
gemfile文件下添加配置
```
# 静态配置
gem 'settingslogic', '~> 2.0.9'
```
在models文件夹下新建`email_settings.rb`
```
# models/email_settings.rb
class EmailSettings < Settingslogic
  source "#{Rails.root}/config/email_settings.yml"
  namespace Rails.env
end

# config文件下新建email_settings.yml文件
defaults: &defaults
  email:
    user_name: 'your_email_name' # 你的邮箱账户
    password: 'your_email_secret' # 邮箱秘钥,注意不是邮箱密码,是上面开通smtp功能提供的密钥


development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```
然后在config/environments/development.rb使用配置文件
```
# Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.163.com',
    port:                  465,
    domain:               '163.com',
    user_name:            Setting.email.email_name, 
    password:             Setting.email.email_password, 
    authentication:       :plain,
    enable_starttls_auto: true,
    ssl: true
  }
```
在进入`rails c`,执行下面的命令
```
NoticeMailer.notice_email('329414837@qq.com', '123').deliver_now
```
