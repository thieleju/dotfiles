source /usr/share/cachyos-fish-config/cachyos-config.fish

export BROWSER=nemo

# overwrite greeting
function fish_greeting
	# Show fastfetch stats but disable the ASCII/logo and prefix each line with a tab + space
	# Run fastfetch inside a pseudo-tty so it preserves colors when piped.
	# Build a structure string that excludes the Colors module (removes the palette)
	set -l structure "Title:Separator:OS:Host:Kernel:Uptime:Packages:Shell:Display:DE:WM:WMTheme:Theme:Icons:Font:Cursor:Terminal:TerminalFont:CPU:GPU:Memory:Swap:Disk:LocalIp:Battery:PowerAdapter:Locale:Break"
	if type -q script
		script -q -c "fastfetch --logo none --structure '$structure'" /dev/null 2>/dev/null | awk '{printf("\t %s\n", $0)}' || true
	else if type -q unbuffer
		unbuffer fastfetch --logo none --structure "$structure" 2>/dev/null | awk '{printf("\t %s\n", $0)}' || true
	else
		# Fallback: direct call (may lose colors when piped)
		fastfetch --logo none --structure "$structure" 2>/dev/null | awk '{printf("\t %s\n", $0)}' || true
	end
end

