module Dialogs
  class AddAnime
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr, title = nil)
      # Create an empty dialog box
      dlg = FXDialogBox.new(window, "Add Anime")

      # Set up its contents
      vframe = FXVerticalFrame.new(dlg, LAYOUT_FILL_X|LAYOUT_FILL_Y)
      FXLabel.new(vframe, "Title:", nil, LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      anime_title_field = FXTextField.new(vframe, 100,
                                          :opts => JUSTIFY_LEFT|FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      anime_title_field.text = title
      FXLabel.new(vframe, "Save Path:", nil, LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      save_path_field = FXTextField.new(vframe, 100,
                                        :opts => JUSTIFY_LEFT|FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      save_path_field.text = "#{window.configuration.downloads_directory}#{title}"

      anime_title_field.connect(SEL_COMMAND) do
        save_path_field.text = "#{window.configuration.downloads_directory}#{anime_title_field.text}"
      end

      hframe = FXHorizontalFrame.new(vframe, LAYOUT_FILL_X|LAYOUT_FILL_Y)

      FXButton.new(hframe, "Cancel", nil, dlg, FXDialogBox::ID_CANCEL,
                   FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      FXButton.new(hframe, "  OK  ", nil, dlg, FXDialogBox::ID_ACCEPT,
                   FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)

      # FXDialogBox#execute will return non-zero if the user clicks OK
      if dlg.execute != 0
        perform(anime_title_field, save_path_field)
      end
    end

    def perform(anime_title_field, save_path_field)
      anime_title = anime_title_field.text
      window.repository.add!(
        title: anime_title,
        feeds: window.configuration.rss_feeds,
        category: window.configuration.category,
        save_path: save_path_field.text
      )
      window.table.insertRows(window.table.numRows, 1)
      anime_data = window.repository.find(anime_title)

      last_row_idx = window.table.numRows - 1
      window.table.setItemText(last_row_idx, 0, anime_title)
      window.table.setItemText(last_row_idx, 1, anime_data['savePath'])
      window.table.setItemJustify(last_row_idx, 0, FXTableItem::LEFT|FXTableItem::CENTER_Y)
      window.table.setItemJustify(last_row_idx, 1, FXTableItem::LEFT|FXTableItem::CENTER_Y)
      window.table.setRowText(last_row_idx, "#{last_row_idx+1}")
    end
  end
end