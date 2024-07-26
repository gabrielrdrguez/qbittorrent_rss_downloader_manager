module Dialogs
  class OpenFile
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr)
      file_dialog = FXFileDialog.new(window, "Open JSON")
      file_dialog.patternList = ["*.json"]
      if file_dialog.execute != 0
        rules_json = RSS::Rules::File.load_file(file_dialog.filename)
        window.repository.load(rules_json)
        window.title = "RSS Download Manager - #{file_dialog.filename}"
        window.configuration.last_file = file_dialog.filename
        window.configuration.save
        window.table.redraw_data
      end
    end
  end
end
