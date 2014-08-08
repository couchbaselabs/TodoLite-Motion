class Titled < CBLModelBase
  attr_reader :created_at
  attribute :title, :created_at

  # abstract needs to be overwritten in the child class
  def self.docType
    raise NotImplementedError
  end

  def initInDatabase database, withTitle: title
    self.initWithNewDocumentInDatabase database
    self.setValue(self.class.docType, ofProperty: "type")
    self.title = title
    self.created_at = NSDate.date
    self
  end
end

