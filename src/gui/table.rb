class MainWindow
  class Table < Fox::FXTable
    include Responder

    def initialize(*args, &block)
      super(*[args[0], args[2]], &block)
      @repository = args[1]

      self.visibleRows = 30
      self.rowHeaderWidth = 30
      self.backColor = FXRGB(255, 255, 255)

      # FXMAPFUNC(SEL_COMMAND, FXTable::ID_ACCEPT_INPUT, 'on_accept_input')
      # FXMAPFUNC(SEL_COMMAND, FXTable::ID_PASTE_SEL, 'on_paste')
    end

    def redraw_data
      setTableSize(@repository.count, 2)

      # Initialize the scrollable part of the table
      @repository.each.with_index do |(title, values), idx|
        setItemText(idx, 0, title)
        setItemText(idx, 1, values['savePath'])
        setItemJustify(idx, 0, FXTableItem::LEFT|FXTableItem::CENTER_Y)
        setItemJustify(idx, 1, FXTableItem::LEFT|FXTableItem::CENTER_Y)
        getItem(idx, 0).enabled = false

        setCellColor(0, 0, FXRGB(248, 248, 255))
        setCellColor(0, 1, FXRGB(248, 248, 255))

        setCellColor(1, 0, FXRGB(198, 226, 255))
        setCellColor(1, 1, FXRGB(198, 226, 255))
      end

      setColumnWidth(0, 340)  # Set the width of the first column to 300 pixels
      setColumnWidth(1, 600)  # Set the width of the second column to 600 pixels

      # Initialize column headers
      %w[Title Save\ Path].each_with_index { |text, idx| setColumnText(idx, text) }

      # Initialize row headers
      (0..@repository.count-1).each { |r| setRowText(r, "#{r+1}") }
    end
  end
end