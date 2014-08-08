class List < Titled
  def self.docType
    "list"
  end

  def self.queryListsInDatabase database
    view = database.viewNamed("lists")
    Blocks.setupListsMapBlockForView(view)
    view.createQuery
  end

  def self.updateAllListsInDatabase database, withOwner:owner, error:error
    lists = List.queryListsInDatabase(database).run(error)
    return if error

    lists.each do |raw_list|
      list = List.modelForDocument(raw_list.document)
      list.owner = owner
      return if !list.save(error)
    end
  end

  def owner= user
    self.setValue(user, ofProperty: "owner")
  end

  def addTaskWithTitle title
    Task.alloc.initInList(self, withTitle:title)
  end

  def queryTasks
    view = document.database.viewNamed("tasksByDate")
    Blocks.setupTasksMapBlockForView(view)

    query = view.createQuery
    query.descending = true
    list_id = document.documentID
    query.startKey = [list_id, {}]
    query.endKey = [list_id]
    query
  end
end

