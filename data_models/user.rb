class User
  attr_accessor :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status,
    :tokens, :company

  def initialize(raw_hash:, company:)
    @id = raw_hash['id']
    @first_name = raw_hash['first_name']
    @last_name = raw_hash['last_name']
    @email = raw_hash['email']
    @company_id = raw_hash['company_id']
    @email_status = raw_hash['email_status']
    @active_status = raw_hash['active_status']
    @tokens = raw_hash['tokens']
    set_company_association(company)
  end

  def can_receive_email?
    self.email_status && company&.email_status
  end

  def new_token_balance
    can_get_token_top_up? ? self.tokens.to_i + company.top_up.to_i : self.tokens.to_i
  end

  def can_get_token_top_up?
    !company.nil? && active_status
  end

  private
  def set_company_association(company)
    return unless company && company.id == @company_id
    @company = company
  end
end
