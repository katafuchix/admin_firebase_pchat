# frozen_string_literal: true

class Firestorage::ProfilePhoto < Firestorage::Base

  def self.upload(imageFile)
    file = bucket.create_file(imageFile.tempfile,"ProfilePhoto_test/1/avarar.jpg", acl: "public")
    file.public_url
  end

end
