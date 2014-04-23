class FacebookSyncAuthenticator
  def initialize application_id, sync_manager
    @application_id = application_id
    @sync_manager = sync_manager
  end

  def credentials &block
    authenticate do |account|
      user_info(account) do |info|
        @sync_manager.user_id = info["email"]
        block.call user_id, info
      end
    end
  end

  def register_credentials_for_replications replications
    return unless user_id
    replications.each do |replication|
      replication.setFacebookEmailAddress user_id
      replication.registerFacebookToken access_token forEmailAddress:user_id
    end
  end

  def authenticate &block
    account_store = ACAccountStore.alloc.init
    fb_account_type = account_store.accountTypeWithAccountTypeIdentifier( ACAccountTypeIdentifierFacebook)
    facebook_options = {}
    facebook_options[ACFacebookAppIdKey] = @application_id
    facebook_options[ACFacebookPermissionsKey] = ["email"]

    account_store.requestAccessToAccountsWithType(fb_account_type, options:facebook_options, completion: lambda do |granted, error|
      if granted
        accounts = account_store.accountsWithAccountType(fb_account_type)
        fb_account = accounts.last
        @access_token = fb_account.credential.oauthToken
        NSUserDefaults.standardUserDefaults.setObject @access_token, forKey:access_token_key
        block.call fb_account
      else
        Dispatch::Queue.main.async do
          alert = UIAlertView.alloc.initWithTitle("Account Error",
                                          message:"There is no Facebook Accounts configured. You can configure a Facebook acount in Settings.",
                                          delegate:nil,
                                          cancelButtonTitle:"Ok",
                                          otherButtonTitles: nil)
          alert.show
        end
      end
    end)
  end

  def user_info account, &block
    url = NSURL.URLWithString("https://graph.facebook.com/me")
    request = SLRequest.requestForServiceType(SLServiceTypeFacebook,
                                              requestMethod: SLRequestMethodGET,
                                              URL: url,
                                              parameters: nil)
    request.account = account
    request.performRequestWithHandler(lambda do |data, response, error|
      if error.nil? && response.statusCode == 200
        block.call BW::JSON.parse(data)
      end
    end)
  end

  def access_token
    @access_token ||= NSUserDefaults.standardUserDefaults.objectForKey(access_token_key)
  end

  def user_id
    @user_id ||= @sync_manager.user_id
  end

  def access_token_key
    "CBLFBAT-#{user_id}"
  end

end
