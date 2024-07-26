module Dialogs
  class HowTo
    def initialize(window)
      @window = window
    end

    attr_reader :window

    def render(sender, sel, ptr)
      FXMessageBox.information(
        window, MBOX_OK, "How To",
        "1. File > Open RSS file\n" +
          "2. Edit > Add Anime or Add from clipboard (anime title) \n" +
          "3. Change the path if you're not happy\n" +
          "4. File > Save\n" +
          "5. Import the RSS File\n" +
          "6. Done!"
      )
    end
  end
end