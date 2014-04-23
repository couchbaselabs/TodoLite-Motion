class TasksViewController < UIViewController

  attr_accessor :current_list, :data_source

  def viewDidLoad
    self.navigationItem.title = "Tasks"

    @tasks_table = UITableView.alloc.initWithFrame(view.bounds)
    @tasks_table.delegate = self
    @data_source = CBLUITableSource.alloc.init
    @data_source.query = current_list.queryTasks.asLiveQuery
    @data_source.tableView = @tasks_table
    @data_source.labelProperty = "title"
    @tasks_table.dataSource = @data_source

    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"add_task")

    self.view.addSubview @tasks_table
  end

  def add_task
    alert = UIAlertView.alloc.initWithTitle("New task",
                                            message:"Title",
                                            delegate: self,
                                            cancelButtonTitle:"Cancel",
                                            otherButtonTitles:"Create", nil)
    alert.alertViewStyle = UIAlertViewStylePlainTextInput
    alert.show
  end

  def alertView alert, didDismissWithButtonIndex:index
    if index > 0
      title = alert.textFieldAtIndex(0).text
      create_task(title) if title.length > 0
    end
  end

  def create_task title
    task = current_list.addTaskWithTitle(title)
    error_ptr = Pointer.new(:object)
    task.save(error_ptr)
    if error_ptr[0]
      alert = UIAlertView.alloc.initWithTitle("Error",
                                      message: "Failed to create new task",
                                      delegate: nil,
                                      cancelButtonTitle: "Ok",
                                      otherButtonTitles: nil)
      alert.show
    else
      task
    end
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    row = @data_source.rowAtIndex(indexPath.row)
    task = Task.modelForDocument(row.document)
    task.checked = !task.checked
    error_ptr = Pointer.new(:object)
    task.save(error_ptr)
    if error_ptr[0]
      alert = UIAlertView.alloc.initWithTitle("Error",
                                      message: "Failed to update task",
                                      delegate: nil,
                                      cancelButtonTitle: "Ok",
                                      otherButtonTitles: nil)
      alert.show
    end
  end

  def couchTableSource source, cellForRowAtIndexPath:indexPath
    cell_identifier = "Task"
    cell = @tasks_table.dequeueReusableCellWithIdentifier(cell_identifier) || begin
      cell = TaskTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cell_identifier)
      cell.create_label
    end
    row = source.rowAtIndex(indexPath.row)
    task = Task.modelForDocument(row.document)
    cell.task = task
    cell
  end

  def couchTableSource source, updateFromQuery:query, previousRows:previousRows
    @tasks_table.reloadData
  end
end
