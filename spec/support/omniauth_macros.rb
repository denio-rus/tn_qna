module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] =  OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'email' => 'github@user.com',
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })

    OmniAuth.config.mock_auth[:vkontakte] =  OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '123545',
      'info' => {
        'email' => 'vk@user.com',
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })

    OmniAuth.config.mock_auth[:vkontakte_no_mail] =  OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '123546',
      'info' => {},
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end