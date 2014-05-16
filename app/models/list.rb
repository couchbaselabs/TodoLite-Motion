class List < Titled
  def self.docType
    "list"
  end

  def self.queryListsInDatabase database
    view = database.viewNamed("lists")

    unless view.hasMapBlock
      view.setMapBlock(lambda { |doc, emit|
        if doc["type"] == "list"
          emit doc["title"], nil
        end
      }, reduceBlock: nil, version: "1")
    end

    view.createQuery
  end

  def self.updateAllListsInDatabase database, withOwner:owner, error:error
    lists = List.queryListsInDatabase(database).run(error)
    return if error

    lists.each do |raw_list|
      list = List.modelForDocument(raw_list.document)
      list.owner = owner
      list.save(error)
      return if error
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

    unless view.hasMapBlock
      view.setMapBlock(lambda { |doc, emit|
        if doc["type"] == "list"
          date = doc["created_at"]
          list_id = doc["list_id"]
          emit([list_id, date], nil)
        end
      }, reduceBlock: nil, version: "1")
    end

    query = view.createQuery
    query.descending = true
    list_id = document.documentID
    query.startKey = [list_id, {}]
    query.endKey = [list_id]
    query
  end
end

