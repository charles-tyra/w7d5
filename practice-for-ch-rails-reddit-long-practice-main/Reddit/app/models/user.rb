require 'BCrypt'

class User < ApplicationRecord            #FIGVAPEBR        FIBVAPER
   validates :username, :session_token, uniqueness: true, presence: true
   validates :password_digest, presence: true
   validates :password, length: { minimum: 6 }, allow_nil: true

   before_validation :ensure_session_token

   attr_reader :password

   def self.find_by_credentials(username, password)
      user = User.find_by(username: username)

      user && user.is_password?(password) ? user : nil
   end

   def is_password?(pass)
      pass_obj = BCrypt::Password.new(self.password_digest)
      pass_obj.is_password?(pass)
   end

   def password=(password)
      self.password_digest = BCrypt::Password.create(password)
      @password = password
   end

   def ensure_session_token
      self.session_token ||= SecureRandom::urlsafe_base64
   end   

   def reset_session_token!
      self.session_token = SecureRandom::urlsafe_base64
      self.save!
      self.session_token
   end
end
