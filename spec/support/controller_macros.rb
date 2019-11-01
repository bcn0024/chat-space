module ControllerMacros  # deviseをrspecで使用する準備
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end