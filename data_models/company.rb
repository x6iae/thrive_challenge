class Company
  attr_accessor :id, :name, :top_up, :email_status

  def initialize(raw_hash)
    @id = raw_hash['id']
    @name = raw_hash['name']
    @top_up = raw_hash['top_up']
    @email_status = raw_hash['email_status']
  end
end
