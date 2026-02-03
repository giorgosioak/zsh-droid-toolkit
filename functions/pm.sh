#!/bin/zsh

pm() {
  # Dependency check
  if ! command -v adb &> /dev/null; then
    print -P "%F{red}Error: 'adb' not found. Please install Android Platform Tools.%f"
    return 1
  fi

  local cmd=$1
  local target=$2

  # Zsh Color definitions
  local RED='%F{160}'
  local GREEN='%F{082}'
  local YELLOW='%F{220}'
  local CYAN='%F{045}'
  local BOLD='%B'
  local NC='%f%b' 

  # Usage Menu
  if [[ -z "$cmd" || -z "$target" ]]; then
    print -P "%B${CYAN}Package Manager Helper${NC}"
    print -P "${YELLOW}Usage:${NC} pm ${CYAN}<command>${NC} ${GREEN}<package_name>${NC}"
    print -P ""
    print -P "  ${CYAN}f, find     ${NC} Search packages (case-insensitive)"
    print -P "  ${CYAN}d, download ${NC} Pull APK to current directory"
    print -P "  ${CYAN}l, log      ${NC} Stream color-coded logs for app"
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
    l|log)
      local pid=$(adb shell pidof -s "$target" | tr -d '\r\n')

      if [[ -z "$pid" ]]; then
        print -P "${YELLOW}App '$target' is not running.${NC}"
        print -Pn "Launch it now? [y/N]: "
        read -k 1 launch
        echo
        if [[ "$launch" == [yY] ]]; then
            adb shell monkey -p "$target" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
            sleep 2
            pid=$(adb shell pidof -s "$target" | tr -d '\r\n')
        else
            return 1
        fi
      fi

      if [[ -n "$pid" ]]; then
        print -P "${GREEN}✔ Logging Started${NC} (PID: $pid)"
        print -P "${YELLOW}Press Ctrl+C to stop...${NC}"
        # -v color: Native colors, -v brief: clean headers
        adb logcat -v color -v brief --pid="$pid" "*:V"
      else
        print -P "${RED}Error:${NC} Could not capture PID for $target."
      fi
      ;;
    r|remove)
      print -Pn "${YELLOW}Uninstall '$target'? [y/N] ${NC}"
      read -k 1 confirm
      echo 
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