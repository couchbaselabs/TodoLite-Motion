class ListsViewController < UIViewController
  attr_accessor :database, :user_id, :navigation_controller, :data_source

  def viewDidLoad
    super
    navigationItem.title = "Todo Lists"

    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:"add_list")

    @lists_table = UITableView.alloc.initWithFrame(view.bounds)
    @lists_table.delegate = self
    @data_source = CBLUITableSource.alloc.init
    @data_source.query = List.queryListsInDatabase(database).asLiveQuery
    @data_source.labelProperty = "title"
    @data_source.tableView = @lists_table
    @lists_table.dataSource = @data_source

    view.addSubview @lists_table
  end

  def add_list
    alert = UIAlertView.alloc.initWithTitle("New list", message:"Title", delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles:"Create", nil)
    alert.alertViewStyle = UIAlertViewStylePlainTextInput
    alert.show
  end

  def alertView alert, didDismissWithButtonIndex:index
    if index > 0
      title = alert.textFieldAtIndex(0).text
      if title.length > 0
        list = create_list(title)
        show_list(list) if list
      end
    end
  end

  def create_list title
    owner = Profile.profileInDatabase(database, forUserID:user_id)
    list = List.alloc.initInDatabase(database, withTitle:title)
    list.owner = owner
    error_ptr = Pointer.new(:object)
    list.save(error_ptr)
    if error_ptr[0]
      alert = UIAlertView.alloc.initWithTitle("Error", message: "Failed to create new list", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: nil)
      alert.show
    else
      list
    end
  end

  def couchTableSource source, updateFromQuery:query, previousRows:previousRows
    @lists_table.reloadData
  end

  def couchTableSource source, willUseCell:cell, forRow:row
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    row = @data_source.rowAtIndex(indexPath.row)
    list = List.modelForDocument(row.document)
    show_list list
  end

  def show_list list
    tasks_view = TasksViewController.alloc.init
    tasks_view.current_list = list
    navigation_controller.pushViewController tasks_view, animated:true
  end
end
