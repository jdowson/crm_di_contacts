class Lookup < ActiveRecord::Base

#  attr_protected :admin, :suspended_at

#  before_destroy :check_if_has_related_assets

  has_one     :avatar, :as => :entity, :dependent => :destroy  # Personal avatar.

  has_many    :activities,  :dependent => :destroy

  #named_scope :except, lambda { |user| { :conditions => [ "id != ? ", user.id ] } }
  #named_scope :by_name, :order => "first_name, last_name, email"
  default_scope :order => "name DESC"

#  simple_column_search :username, :first_name, :last_name, :escape => lambda { |query| query.gsub(/[^\w\s\-\.']/, "").strip }

  acts_as_paranoid
  acts_as_authentic do |c|
    c.session_class = Authentication
    c.validates_uniqueness_of_login_field_options = { :message => :username_taken }
    c.validates_uniqueness_of_email_field_options = { :message => :email_in_use }
    c.validates_length_of_password_field_options  = { :minimum => 0, :allow_blank => true, :if => :require_password? }
    c.ignore_blank_passwords = true
  end

  # Store current user in the class so we could access it from the activity
  # observer without extra authentication query.
  cattr_accessor :current_user

  validates_presence_of :username, :message => :missing_username

  private

  # Prevent deleting a user unless she has no artifacts left.
  #----------------------------------------------------------------------------
  def check_if_has_related_assets
    artifacts = %w(Account Campaign Lead Contact Opportunity Comment).inject(0) do |sum, asset|
      klass = asset.constantize
      sum += klass.assigned_to(self).count if asset != "Comment"
      sum += klass.created_by(self).count
    end
    artifacts == 0
  end

end
