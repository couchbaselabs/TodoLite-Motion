class Task < Titled
  attr_reader :list_id

  def self.docType
    "task"
  end

  def initInList list, withTitle:title
    self.initInDatabase(list.document.database, withTitle:title)
    self.list_id = list
    self.checked = false
    self
  end

  def checked= value
    setValue value, ofProperty:"checked"
  end

  def checked
    getValueOfProperty "checked"
  end

  def list_id= id
    setValue id, ofProperty:"list_id"
  end

  def to_s
    "#{self.class}[#{document.abbreviatedID}, #{self.title}, #{checked}]"
  end
end

