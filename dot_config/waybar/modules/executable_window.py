#!/usr/bin/env python3

import json
import subprocess
import sys
import os


def main():
    # If Waybar provides an OUTPUT environment variable, try to select the active
    # window for that monitor's active workspace; otherwise fall back to the
    # global active window.
    WAYBAR_OUTPUT = os.getenv("WAYBAR_OUTPUT") or os.getenv("WAYBAR_BAR_OUTPUT") or os.getenv("WAYBAR_MONITOR") or os.getenv("WAYBAR_OUTPUT_NAME")
    try:
        if WAYBAR_OUTPUT:
            # Find monitor and its active workspace
            monitors = json.loads(subprocess.check_output(["hyprctl", "monitors", "-j"]).decode())
            monitor = None
            for m in monitors:
                if m.get("name") == WAYBAR_OUTPUT or str(m.get("id")) == WAYBAR_OUTPUT:
                    monitor = m
                    break
            if not monitor:
                # Fallback to global activewindow
                res = subprocess.run(["hyprctl", "activewindow", "-j"], capture_output=True, text=True, check=False)
                stdout = res.stdout.strip()
                if not stdout:
                    print(json.dumps({"text": "", "class": "hidden"}))
                    return
                data = json.loads(stdout)
            else:
                # Get workspace name for that monitor
                ws = monitor.get("activeWorkspace") or {}
                ws_name = ws.get("name") or ws.get("id")
                # List clients and find clients on that workspace
                clients = json.loads(subprocess.check_output(["hyprctl", "clients", "-j"]).decode())
                # Filter clients by workspace name (or id) and choose most recently focused (highest focusHistoryID)
                matches = [c for c in clients if str(c.get("workspace", {}).get("name")) == str(ws_name) or str(c.get("workspace", {}).get("id")) == str(ws_name)]
                if not matches:
                    print(json.dumps({"text": "", "class": "hidden"}))
                    return
                # Choose the client with the highest focusHistoryID
                candidate = max(matches, key=lambda c: c.get("focusHistoryID", 0))
                data = candidate
        else:
            res = subprocess.run(["hyprctl", "activewindow", "-j"], capture_output=True, text=True, check=False)
            stdout = res.stdout.strip()
            if not stdout:
                print(json.dumps({"text": "", "class": "hidden"}))
                return
            data = json.loads(stdout)
    except Exception:
        print(json.dumps({"text": "", "class": "hidden"}))
        return

    title = (data.get("title") or "").strip()
    if not title:
        print(json.dumps({"text": "", "class": "hidden"}))
    else:
        print(json.dumps({"text": title, "class": "window"}))


if __name__ == '__main__':
    main()
