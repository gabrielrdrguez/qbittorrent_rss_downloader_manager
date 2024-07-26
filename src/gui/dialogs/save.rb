module Dialogs
  class Save
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr)
      perfom

      dlg = FXDialogBox.new(window, "Save")
      dlg.width = 100
      # Set up its contents
      frame = FXVerticalFrame.new(dlg, LAYOUT_FILL_X|LAYOUT_FILL_Y)
      FXLabel.new(frame, "Success!", nil, LAYOUT_CENTER_X|LAYOUT_CENTER_Y)
      FXButton.new(frame, "  OK  ", nil, dlg, FXDialogBox::ID_ACCEPT,
                   FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      if dlg.execute != 0
        dlg.close
      end

      return 1
    end

    def perfom
      window.table.each_row do |row|
        window.repository.update!(row[0].text, 'savePath' => row[1].text)
      end
      RSS::Rules::File.save(window.repository.repo)
      window.table.redraw_data
    end
  end
end
