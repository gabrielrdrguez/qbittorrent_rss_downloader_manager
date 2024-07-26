module Dialogs
  class About
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr)
      FXMessageBox.information(
        window, MBOX_OK, "About RSS Download Manager",
        "Just a tool to help add RSS feeds to a Qbittorrent json file and a learning playground for FXRuby\n" +
          "https://github.com/gabrielrdrguez"
      )
    end
  end
end