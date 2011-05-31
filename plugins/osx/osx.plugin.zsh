alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'

# Recursively delete .DS_Store files
alias rm-dsstore="find . -name '*.DS_Store' -type f -delete"

function savepath() {
  pwd > ~/.current_path~
}

function tab() {
savepath
osascript >/dev/null <<EOF
on do_submenu(app_name, menu_name, menu_item, submenu_item)
    -- bring the target application to the front
    tell application app_name
      activate
    end tell
    tell application "System Events"
      tell process app_name
        tell menu bar 1
          tell menu bar item menu_name
            tell menu menu_name
              tell menu item menu_item
                tell menu menu_item
                  click menu item submenu_item
                end tell
              end tell
            end tell
          end tell
        end tell
      end tell
    end tell
end do_submenu

do_submenu("Terminal", "Shell", "New Tab", 1)
EOF
}

function itab() {
savepath
osascript >/dev/null <<EOF
on do_submenu(app_name, menu_name, menu_item)
    -- bring the target application to the front
    tell application app_name
      activate
    end tell
    tell application "System Events"
      tell process app_name
        tell menu bar 1
          tell menu bar item menu_name
            tell menu menu_name
              click menu item menu_item
            end tell
          end tell
        end tell
      end tell
    end tell
end do_submenu

do_submenu("iTerm", "Shell", "New Tab")
EOF
}
