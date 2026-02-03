#!/bin/zsh

pm() {
  # Dependency check
  if ! command -v adb &> /dev/null; then
    print -P "%F{red}Error: 'adb' not found. Please install Android Platform Tools.%f"
    return 1
  fi

  local cmd=$1
  local target=$2

  # Zsh Color definitions (using %F for foreground, %B for bold)
  local RED='%F{160}'
  local GREEN='%F{082}'
  local YELLOW='%F{220}'
  local CYAN='%F{045}'
  local NC='%f%b' 

  # Usage Menu
  if [[ -z "$cmd" || -z "$target" ]]; then
    print -P "%B${CYAN}Package Manager Helper${NC}"
    print -P "${YELLOW}Usage:${NC} pm ${CYAN}<command>${NC} ${GREEN}<package_name>${NC}"
    print -P ""
    print -P "  ${CYAN}f, find     ${NC} Search packages (case-insensitive)"
    print -P "  ${CYAN}d, download ${NC} Pull APK to current directory"
    print -P "  ${CYAN}c, clear    ${NC} Force-stop & wipe app data/cache"
    print -P "  ${CYAN}r, remove   ${NC} Uninstall package from device"
    return 1
  fi

  case "$cmd" in
    f|find)
      print -P "${CYAN}Searching for:${NC} $target..."
      adb shell pm list packages | grep -i --color=always "$target"
      ;;
    d|download)
      print -P "${CYAN}Locating APK...${NC}"
      local apk_path=$(adb shell pm path "$target" | cut -d':' -f2 | tr -d '\r\n')
      
      if [[ -z "$apk_path" ]]; then
        print -P "${RED}Error:${NC} Package '$target' not found."
        return 1
      fi

      adb pull "$apk_path" "${target}.apk"
      [[ $? -eq 0 ]] && print -P "${GREEN}Success:${NC} ${target}.apk saved."
      ;;
    c|clear)
      print -P "${CYAN}Resetting:${NC} $target..."
      adb shell am force-stop "$target"
      adb shell pm clear "$target"
      [[ $? -eq 0 ]] && print -P "${GREEN}Success: Device storage cleared.${NC}"
      ;;
    r|remove)
      # Zsh 'read' for single keypress confirmation
      print -Pn "${YELLOW}Uninstall '$target'? [y/N] ${NC}"
      read -k 1 confirm
      echo # New line after keypress
      if [[ "$confirm" == [yY] ]]; then
        print -P "${CYAN}Removing...${NC}"
        adb uninstall "$target"
      else
        print "Operation cancelled."
      fi
      ;;
    *)
      print -P "${RED}Unknown command:${NC} $cmd"
      return 1
      ;;
  esac
}