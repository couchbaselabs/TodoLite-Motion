class Profile < CBLModel
  attr_accessor :user_id, :type, :name

  def self.queryProfilesInDatabase
    view = database.viewNamed("profiles")
    Blocks.setupProfilesMapBlockForView(view)
    view.createQuery
  end

  def self.profileInDatabase database, forUserID:userID
    profile_doc_id = "p:#{userID}"
    doc = database.existingDocumentWithID(profile_doc_id)
    doc = Profile.modelForDocument(doc)
  end

  def initCurrentUserProfileInDatabase database, withName:name, andUserID:userID
    profile_doc_id = "p:#{userID}"
    doc = database.documentWithID(profile_doc_id)
    self.initWithDocument doc
    self.name = name
    self.user_id = userID
    self.type = "profile"
    self
  end

  def description
    "#{self.class} [#{document.abbreviatedID} #{self.user_id}]"
  end
end

