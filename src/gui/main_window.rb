require 'fox16'
include Fox

class MainWindow < FXMainWindow
  require_relative 'menu'
  require_relative 'table'
  require_relative 'dialogs/add_anime'
  require_relative 'dialogs/save'
  require_relative 'dialogs/preferences'
  require_relative 'dialogs/about'
  require_relative 'dialogs/how_to'
  require_relative 'dialogs/open_file'

  def initialize(app, repository, configuration)
    super(app, "RSS Download Manager - #{configuration.last_file}", :opts => DECOR_ALL, :width => 1000)
    @repository = repository
    @configuration = configuration

    menu = Menu.new(self)

    FXHorizontalSeparator.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|SEPARATOR_GROOVE)
    contents = FXVerticalFrame.new(self, LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    frame = FXVerticalFrame.new(contents,FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y, :padding => 0)
    initialize_table(frame)

    # renders menu after the table because it needs window.table to exist "¯\_(ツ)_/¯"
    menu.render
  end

  attr_reader :table, :repository, :configuration

  def initialize_table(frame)
    @table = Table.new(
      frame,
      @repository,
      :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|TABLE_NO_COLSELECT|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      :padding => 2
    )

    @table.connect(SEL_DELETED) { |sender, selector, data|
      app.addChore{ on_sel_delete(sender, selector, data) }
    }

    @table.redraw_data
  end

  def on_sel_delete(sender, sel, ptr)
    row = sender.currentRow
    title = sender.getItemText(row,0)
    @repository.delete!(title)
    @table.redraw_data
    1
  end

  # Create and show this window
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
