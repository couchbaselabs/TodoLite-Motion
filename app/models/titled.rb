class Titled < CBLModel
  attr_reader :title, :created_at

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

  def title
    getValueOfProperty "title"
  end

  def title= new_title
    self.setValue(new_title, ofProperty: "title")
  end

  def created_at= date
    self.setValue(date, ofProperty: "created_at")
  end

  def to_s
    "#{self.class}[#{document.abbreviatedID}, #{title}]"
  end
end

