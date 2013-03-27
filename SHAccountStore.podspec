Pod::Spec.new do |s|
  s.name         = "SHAccountStore"
  s.version      = "0.0.1"
  s.summary      = "Account Storage similar to ACAccount - using Keychain instead of Core Data."
  s.description  = <<-DESC
                    A Keychain based Account Storage similar to ACAccount for third party providers. 
  
                    * SHAccount.
                    * SHAccountType
                    * SHAccountCredential
                    * SHAccountStore

                    The api works the same way as the Accounts framework.
                   DESC
  s.homepage     = "https://github.com/seivan/SHAccountStore"

  s.license      = {:type => 'MIT' } #,:file => 'LICENSE.md'
  s.author       = { "Seivan Heidari" => "seivan.heidari@icloud.com" }
  
  s.source       = { :git => "https://github.com/seivan/SHAccountStore.git", :commit => "986139c95bddf91f82cd2dd1547fc8020d8074d5" }
  

  s.platform  = :ios, "5.0"

  s.source_files = 'SHAccountStore'

  s.requires_arc = true
  s.dependency 'LUKeychainAccess'
  s.dependency 'BlocksKit'
end
