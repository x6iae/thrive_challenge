class User
  attr_accessor :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status,
    :tokens

  def initialize(raw_hash)
    @id = raw_hash['id']
    @first_name = raw_hash['first_name']
    @last_name = raw_hash['last_name']
    @email = raw_hash['email']
    @company_id = raw_hash['company_id']
    @email_status = raw_hash['email_status']
    @active_status = raw_hash['active_status']
    @tokens = raw_hash['tokens']
  end
end
