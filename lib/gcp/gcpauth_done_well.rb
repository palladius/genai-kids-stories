=begin
    
1. token howto: https://stackoverflow.com/questions/73744365/generate-a-gcp-bearer-token-using-ruby
2. Error: 
https://stackoverflow.com/questions/10079149/fetch-access-token-in-google-api-missing-authorization-code

=end
class GCPAuthDoneWell

    def self.gcp_get_auth_token()
        require 'googleauth'
        puts 'Ciao Riccardo. I larnt a lot from SO. 2.'
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open('private/sa.json'))
#        token = authorizer.fetch_access_token!
#token = authorizer.fetch_access_token!(scope: 'https://www.googleapis.com/auth/cloud-platform')
        gatr = authorizer.generate_access_token_request
        puts("gutr: #{gatr['assertion']}")
        # not sure if its ok as bearer or not
        return gatr['assertion']
        token = authorizer.fetch_access_token!(scope: 'cloud-platform')
        puts("[DEB] Token: '#{token}'")
        return token
        # is it ik
    end

    # Token is a "ya29.blah"
    def self.old_way
        old_token = `gcloud auth print-access-token`
        puts("Old token: #{old_token}")
        old_token
    end
end

# example: eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJyaW ...

GCPAuthDoneWell.old_way()
puts('-------')
GCPAuthDoneWell.gcp_get_auth_token()