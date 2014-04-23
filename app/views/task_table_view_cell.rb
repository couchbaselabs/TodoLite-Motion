class TaskTableViewCell < UITableViewCell
  attr_reader :task

  def create_label
    @text_label = UILabel.alloc.init
    self.contentView.addSubview(@text_label)
    self
  end

  def layoutSubviews
    super
    x = self.contentView.bounds.origin.x
    y = self.contentView.bounds.origin.y
    width = self.contentView.bounds.size.width
    height = self.contentView.bounds.size.height

    @text_label.frame = CGRectMake(x + 10, y + 10, width - 20, height - 20)
  end

  def task= new_task
    @task = new_task

    if @task.checked
      attributes = { NSStrikethroughStyleAttributeName => NSUnderlineStyleSingle }
      text = NSAttributedString.alloc.initWithString(@task.title, attributes:attributes)
      @text_label.textColor = UIColor.grayColor
      @text_label.attributedText = text
    else
      @text_label.text = @task.title
      @text_label.textColor = UIColor.blackColor
    end
  end
end

