class Task < Titled
  attribute :checked, :list_id

  def self.docType
    "task"
  end

  def initInList list, withTitle:title
    self.initInDatabase(list.document.database, withTitle:title)
    self.list_id = list
    self.checked = false
    self
  end
end

