class User < ActiveRecord::Base

  validates_uniqueness_of :username,:scope=> [:is_deleted],:if=> 'is_deleted == false'
  validates_length_of :username, :within => 1..20
  validates_length_of :password , :within => 4..40, :allow_nil => true
  validates_format_of :username, :with  => /\A[a-zA-Z]+\z/, :message => "must contain only letters"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "must be a valid email address"
  # validates_presence_of :role
  validates_presence_of :email, :on => :create
  validates_presence_of :password, :on => :create
  
  scope :active, -> {where(is_deleted: false)}
  scope :inactive,-> {where(is_deleted: true)}
  
  # has_and_belongs_to_many :privileges
  
  def before_save
    self.salt = random_string(8) if self.salt == nil
    self.hashed_password = Digest::SHA1.hexdigest(self.salt + self.password) unless self.password.nil?
    
    self.admin, self.student, self.employee = false, false, false
    
    self.admin = true if self.role == 'Admin'
    self.student = true if self .role == 'Student'
    self.employee = true if self.role == 'Employee'
    self.parent = true if self.role == 'Parent'
    self.is_first_login = true
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def self.authenthicate?(username, password)
    u = User.find_by(username: username)
    u.hashed_password == DIgest::SHA1.hexadigest(u.salt + password)
  end
end
