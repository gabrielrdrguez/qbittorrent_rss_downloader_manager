class MainWindow
  class Menu
    def initialize(window)
      @menubar = FXMenuBar.new(window, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
      @window = window
    end

    attr_reader :menubar, :window

    def render
      file_menu
      edit_menu
      options_menu
      help_menu
    end

    def file_menu
      filemenu = FXMenuPane.new(window)
      FXMenuTitle.new(menubar, "&File", nil, filemenu)
      FXMenuCommand.new(filemenu, "&Open RSS file\tCtl-O").connect(SEL_COMMAND) do |sender, sel, ptr|
        Dialogs::OpenFile.new(window).render(sender, sel, ptr)
      end
      FXMenuCommand.new(filemenu, "&Save\tCtl-S").connect(SEL_COMMAND) do |sender, sel, ptr|
        Dialogs::Save.new(window).render(sender, sel, ptr)
      end
      FXMenuCommand.new(filemenu, "&Preferences\tCtl-P").connect(SEL_COMMAND) do |sender, sel, ptr|
        Dialogs::Preferences.new(window).render(sender, sel, ptr)
      end
      FXMenuCommand.new(filemenu, "&Quit\tCtl-Q", nil, window.getApp(), FXApp::ID_QUIT)
    end

    def edit_menu
      manipmenu = FXMenuPane.new(window)
      FXMenuTitle.new(menubar, "&Edit", nil, manipmenu)
      FXMenuCommand.new(manipmenu, "Delete Row\tDel", nil, window.table, FXTable::ID_DELETE_ROW)
      FXMenuCommand.new(manipmenu, "Add Anime\tCtl-D").connect(SEL_COMMAND) do |sender, sel, ptr|
        Dialogs::AddAnime.new(window).render(sender, sel, ptr)
      end

      FXMenuCommand.new(manipmenu, "Add from Clipboard\tCtl-V").connect(SEL_COMMAND) do |sender, sel, ptr|
        title = window.getDNDData(FROM_CLIPBOARD, FXWindow.stringType)
        Dialogs::AddAnime.new(window).render(sender, sel, ptr, title)
      end
    end

    def options_menu
      tablemenu = FXMenuPane.new(window)
      FXMenuTitle.new(menubar, "&Options", nil, tablemenu)
      FXMenuCheck.new(tablemenu, "Horizontal grid", window.table, FXTable::ID_HORZ_GRID)
      FXMenuCheck.new(tablemenu, "Vertical grid", window.table, FXTable::ID_VERT_GRID)
    end

    def help_menu
      help_menu = FXMenuPane.new(window)
      FXMenuTitle.new(menubar, "&Help", nil, help_menu)
      FXMenuCommand.new(help_menu, "About").connect(SEL_COMMAND) do
        Dialogs::About.new(window).render(nil, nil, nil)
      end

      FXMenuCommand.new(help_menu, "How To").connect(SEL_COMMAND) do
        Dialogs::HowTo.new(window).render(nil, nil, nil)
      end
    end
  end
end