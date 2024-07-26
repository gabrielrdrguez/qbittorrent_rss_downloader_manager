module Dialogs
  class Preferences
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr)
      # Create an empty dialog box
      dlg = FXDialogBox.new(window, "Preferences")

      # Set up its contents
      vframe = FXVerticalFrame.new(dlg, LAYOUT_FILL_X|LAYOUT_FILL_Y)
      category_field = render_category(vframe)
      downloads_directory_field = render_download_directory(vframe)
      rss_feeds_list = render_rss_feeds(vframe)

      dialog_buttons(vframe, dlg)

      # FXDialogBox#execute will return non-zero if the user clicks OK
      if dlg.execute != 0
        perform(category_field, downloads_directory_field, rss_feeds_list)
      end
      return 1
    end

    def dialog_buttons(vframe, dlg)
      hframe = FXHorizontalFrame.new(vframe, LAYOUT_FILL_X|LAYOUT_FILL_Y)

      FXButton.new(hframe, "Cancel", nil, dlg, FXDialogBox::ID_CANCEL,
                   FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
      FXButton.new(hframe, "  OK  ", nil, dlg, FXDialogBox::ID_ACCEPT,
                   FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
    end

    def perform(category_field, downloads_directory_field, rss_feed_list)
      window.configuration.category = category_field.text
      window.configuration.downloads_directory = downloads_directory_field.text
      window.configuration.rss_feeds = rss_feed_list.map(&:to_s)
      window.configuration.save
    end

    def render_category(vframe)
      FXLabel.new(vframe, "Category:", nil, LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      category_field = FXTextField.new(vframe, 110,
                                       :opts => JUSTIFY_LEFT|FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      category_field.text = window.configuration.category
      category_field
    end

    def render_download_directory(vframe)
      FXLabel.new(vframe, "Downloads Directory:", nil, LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      downloads_directory_field = FXTextField.new(vframe, 110, :opts => JUSTIFY_LEFT|FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      downloads_directory_field.text = window.configuration.downloads_directory
      downloads_directory_field
    end

    def render_rss_feeds(vframe)
      FXLabel.new(vframe, "RSS Feeds:", nil, LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)

      rss_h_input_frame = FXHorizontalFrame.new(vframe, LAYOUT_FILL_X | LAYOUT_FILL_Y, :padding => 0)
      rss_field = FXTextField.new(rss_h_input_frame, 100, :opts => JUSTIFY_LEFT|FRAME_SUNKEN|FRAME_THICK|LAYOUT_SIDE_LEFT|LAYOUT_CENTER_Y)
      list = FXList.new(vframe,:opts => LIST_NORMAL|LIST_BROWSESELECT|LAYOUT_FILL)
      window.configuration.rss_feeds.each do |rss_feed|
        list.appendItem(rss_feed)
      end

      FXButton.new(rss_h_input_frame, "Add to list").connect(SEL_COMMAND) do
        list.prependItem(rss_field.text) unless rss_field.text == ""
        rss_field.text = nil
      end

      FXButton.new(vframe, "Remove selected").connect(SEL_COMMAND) do
        list.removeItem(list.currentItem) if list.currentItem >= 0
      end

      list
    end
  end
end