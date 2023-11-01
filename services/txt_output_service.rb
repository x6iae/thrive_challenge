module TxtOutputService
  extend self

  OUTPUT_FILE_NAME = 'output.txt'

  def perform(processed_company_token_details)
    # TODO: first clear out the output file for a new write

    # Companies should be ordered by company id.
    # Users should be ordered alphabetically by last name.
    puts processed_company_token_details
  end
end
