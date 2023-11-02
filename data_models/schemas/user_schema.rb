class UserSchema
  SCHEMA = {
    'type' => 'object',
    'required' => ['id', 'first_name', 'last_name', 'email', 'company_id', 'email_status', 'active_status', 'tokens'],
    'properties' => {
      'id' => {'type' => 'integer'},
      'company_id' => {'type' => 'integer'},
      'first_name' => {'type' => 'string'},
      'last_name' => {'type' => 'string'},
      'email' => {'type' => 'string'},
      'tokens' => {'type' => 'integer'},
      'email_status' => {'type' => 'boolean'},
      'active_status' => {'type' => 'boolean'},
    }
  }
end
