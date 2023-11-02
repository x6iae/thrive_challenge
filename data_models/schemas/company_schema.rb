class CompanySchema
  SCHEMA = {
    "type" => "object",
    "required" => ["id", 'name', 'top_up', 'email_status'],
    "properties" => {
      "id" => {"type" => "integer"},
      "name" => {"type" => "string"},
      "top_up" => {"type" => "integer"},
      "email_status" => {"type" => "boolean"},
    }
  }
end
