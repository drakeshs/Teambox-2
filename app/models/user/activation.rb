class User
  
  def send_activation_email
    self.generate_login_code!
    Emailer.deliver_confirm_email self
  end

  def send_reset_password
    self.generate_login_code!
    Emailer.deliver_reset_password self
  end
  
  def is_active?
    self.confirmed_user
  end

  def activate!
    self.confirmed_user = true
    self.save!
    self
  end
  
  def generate_login_code!
    self.login_token = Digest::SHA1.hexdigest(rand(999999999).to_s + self.salt)
    self.login_token_expires_at = 1.month.from_now
    self.save!
  end
  
  def expire_login_code!
    self.login_token_expires_at = 1.minute.ago
    self.save!
  end
  
  def is_login_token_valid?(token)
    (token == self.login_token) and (self.login_token_expires_at > Time.now)
  end
  
end