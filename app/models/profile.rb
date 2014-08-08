class Profile < CBLModelBase

  attribute :name, :user_id

  def self.profile_doc_id user_id
    "p:#{user_id}"
  end

  def idForNewDocumentInDatabase database
    self.class.profile_doc_id @_user_id
  end

  def self.profileInDatabase database, forUserID:userID
    doc = database.existingDocumentWithID(profile_doc_id userID)
    modelForDocument(doc)
  end

  def initCurrentUserProfileInDatabase database, withName:name, andUserID:userID
    # we need to save of the user_id to be used to create the profile doc id
    @_user_id = userID
    self.initWithNewDocumentInDatabase database
    self.setValue("profile", ofProperty: "type")
    self.name = name
    self.user_id = userID
    self
  end
end

