module TxtOutputService
  extend self

  OUTPUT_FILE_NAME = 'output.txt'

  def perform(processed_company_token_details)
    # TODO: first clear out the output file for a new write
    File.open(OUTPUT_FILE_NAME, 'w') {}

    # Companies should be ordered by company id.
    company_keys_sorted = processed_company_token_details.keys.sort

    company_keys_sorted.each do |key|
      write_company_user_data(processed_company_token_details[key])
    end
  end

  private
  def write_company_user_data(processed_company_data)
    company = processed_company_data[:company]
    users = processed_company_data[:users]

    # separate out users emailed from users not emailed
    users_emailed = {}
    users_not_emailed = {}

    # Questions:
    # - are last names unique?
    # - are emails unique otherwise?
    # - are emails always in format of first_name.last_name
    users.each do |user|
      if user.can_receive_email?
        users_emailed[user.last_name.to_s] = user
      else
        users_not_emailed[user.last_name.to_s] = user
      end
    end

    append_company_data_to_output_file(company)
    append_users_emailed_data_to_output_file(users_emailed)
    append_users_not_emailed_data_to_output_file(users_not_emailed)
  end

  def append_users_emailed_data_to_output_file(users)
    heading = 'Users Emailed:'
    append_users_data_to_output_file(users: users, heading: heading)
  end

  def append_users_not_emailed_data_to_output_file(users)
    heading = 'Users Not Emailed:'
    append_users_data_to_output_file(users: users, heading: heading)
  end

  def append_users_data_to_output_file(heading:, users:)
    write_new_line_to_output_file(heading)

    # Users should be ordered alphabetically by last name.
    user_last_names_sorted = users.keys.sort

    user_last_names_sorted.each do |user_name|
      user = users[user_name]
      append_user_data_to_output_file(user)
    end
  end

  def append_company_data_to_output_file(company)
    company_data = <<~COMPANY_DATA
      Company Id: #{company.id}
      Company Name: #{company.name}
    COMPANY_DATA
    write_new_line_to_output_file(company_data)
  end

  def append_user_data_to_output_file(user)
    # TODO: question: should there be a comma after previous token balance?
    user_data = <<~USER_DATA
      \t#{[user.last_name, user.first_name, user.email].join(', ')}
      \t\tPrevious Token Balance, #{user.tokens}
      \t\tNew Token Balance #{user.new_token_balance}
    USER_DATA
    write_new_line_to_output_file(user_data)
  end

  def write_new_line_to_output_file(data)
    File.write(OUTPUT_FILE_NAME, data, mode: 'a')
  end
end
