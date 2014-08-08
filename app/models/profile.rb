class Profile < CBLModel

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
    @_user_id = userID
    self.initWithNewDocumentInDatabase database
    self.setValue("profile", ofProperty: "type")
    self.name = name
    self.user_id = userID
    self
  end

  def name
    getValueOfProperty "name"
  end

  def name= name
    setValue name, ofProperty:"name"
  end

  def user_id
    getValueOfProperty "user_id"
  end

  def user_id= user_id
    setValue user_id, ofProperty:"user_id"
  end

  def to_s
    "#{self.class} [#{document.documentID} #{user_id}]"
  end
end

