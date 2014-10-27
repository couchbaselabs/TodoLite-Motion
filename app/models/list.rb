class List < Titled
  attribute :owner

  def self.docType
    "list"
  end

  def self.queryListsInDatabase database
    view = database.viewNamed("lists")
    if !view.mapBlock
      map = lambda { |doc, emit|
        emit.call(doc["title"], nil) if doc["type"] == "list"
      }
      view.setMapBlock map, reduceBlock: nil, version: "2"
    end
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

  def addTaskWithTitle title
    Task.alloc.initInList(self, withTitle:title)
  end

  def queryTasks
    view = document.database.viewNamed("tasksByDate")
    if !view.mapBlock
      map = lambda { |doc, emit|
        if doc["type"] == "task"
          date = doc["created_at"]
          list_id = doc["list_id"]
          emit.call([list_id, date], nil)
        end
      }
      view.setMapBlock map, reduceBlock: nil, version: "2"
    end

    query = view.createQuery
    query.descending = true
    list_id = document.documentID
    query.startKey = [list_id, {}]
    query.endKey = [list_id]
    query
  end
end

