# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Ignore GUI settings
config.load_autoconfig(False)

storm = {
    'bg':           '#24283b',
    'fg':           '#c0caf5', 
    'blk':          '#32344a',
    'red':          '#f7768e',
    'grn':          '#9ece6a', 
    'ylw':          '#e0af68',
    'blu':          '#7aa2f7',
    'mag':          '#bb9af7',
    'cyn':          '#7dcfff',
    'teal':         '#73dacb',
    'brblk':        '#565f89',
}

xresources = {
    "*.background": storm['bg'],       # #24283b
    "*.foreground": storm['fg'],       # #c0caf5
    "*.color0":     storm['blk'],      # #32344a (darker background)
    "*color6":      storm['cyn'],      # #7dcfff (cyan)
    "*color8":      storm['brblk'],    # #565f89 (muted/selection)
    "*color10":     storm['grn'],      # #9ece6a (green)
    "*color12":     storm['blu'],      # #7aa2f7 (blue)
    "*color13":     storm['mag'],      # #bb9af7 (magenta)
    "*color14":     storm['cyn'],      # #7dcfff (cyan)
}

# This setting is required for transparency to work
c.window.transparent = True

# Define the alpha value for 90% opacity (this is what works!)
alpha = "E6"

# Get base colors
bg_color = xresources["*.background"]  # #24283b
fg_color = xresources["*.foreground"]  # #c0caf5


# Tab bar and inactive tabs: your exact waybar bg-transparent color
c.colors.tabs.bar.bg = "rgba(36, 40, 59, 0.9)"       # Same as waybar bg-transparent
c.colors.tabs.even.bg = "rgba(36, 40, 59, 0.9)"      # Same as waybar bg-transparent  
c.colors.tabs.odd.bg = "rgba(36, 40, 59, 0.9)"       # Same as waybar bg-transparent

# Active/selected tabs: lighter color for contrast (using your brblk but lighter)
c.colors.tabs.selected.even.bg = "rgba(86, 95, 137, 0.9)"  # Lighter than bg-transparent
c.colors.tabs.selected.odd.bg = "rgba(86, 95, 137, 0.9)"   # Lighter than bg-transparent
c.colors.tabs.selected.even.fg = storm['fg']         # #c0caf5
c.colors.tabs.selected.odd.fg = storm['fg']          # #c0caf5

# Tab text colors
c.colors.tabs.even.fg = storm['fg']                  # #c0caf5
c.colors.tabs.odd.fg = storm['fg']                   # #c0caf5

# Tab indicators (your green separator!)
c.colors.tabs.indicator.start = storm['mag']         # #bb9af7 (purple for loading)
c.colors.tabs.indicator.stop = storm['grn']          # #9ece6a (green for loaded)
c.colors.tabs.indicator.error = storm['red']         # #f7768e (red for errors)

# ============================================================================
# STATUS BAR - MATCHING YOUR WAYBAR BG-TRANSPARENT
# ============================================================================

# Status bar: your exact waybar bg-transparent color
c.colors.statusbar.normal.bg = "rgba(36, 40, 59, 0.9)"   # Same as waybar bg-transparent
c.colors.statusbar.command.bg = "rgba(36, 40, 59, 0.9)"  # Same as waybar bg-transparent
c.colors.statusbar.insert.bg = storm['grn']              # #9ece6a (solid green)
c.colors.statusbar.insert.fg = storm['bg']               # #24283b

# Status bar text colors
c.colors.statusbar.normal.fg = storm['cyn']          # #7dcfff
c.colors.statusbar.command.fg = storm['fg']          # #c0caf5
c.colors.statusbar.passthrough.fg = storm['cyn']     # #7dcfff

# URL colors
c.colors.statusbar.url.fg = storm['mag']             # #bb9af7
c.colors.statusbar.url.success.https.fg = storm['grn'] # #9ece6a
c.colors.statusbar.url.success.http.fg = storm['grn']  # #9ece6a
c.colors.statusbar.url.error.fg = storm['red']       # #f7768e
c.colors.statusbar.url.hover.fg = storm['blu']       # #7aa2f7

# ============================================================================
# COMPLETION MENU
# ============================================================================

c.colors.completion.fg = storm['fg']                 # #c0caf5
c.colors.completion.odd.bg = storm['bg']             # #24283b
c.colors.completion.even.bg = storm['blk']           # #32344a
c.colors.completion.category.fg = storm['cyn']       # #7dcfff
c.colors.completion.category.bg = storm['bg']        # #24283b
c.colors.completion.item.selected.fg = storm['fg']   # #c0caf5
c.colors.completion.item.selected.bg = storm['brblk'] # #565f89
c.colors.completion.match.fg = storm['cyn']          # #7dcfff
c.colors.completion.item.selected.match.fg = storm['cyn'] # #7dcfff

# ============================================================================
# OTHER UI ELEMENTS
# ============================================================================

# Hints
c.colors.hints.bg = storm['cyn']                     # #7dcfff
c.colors.hints.fg = storm['bg']                      # #24283b
c.hints.border = f"1px solid {storm['blu']}"

# Messages
c.colors.messages.info.bg = storm['blu']             # #7aa2f7
c.colors.messages.info.fg = storm['bg']              # #24283b
c.colors.messages.error.bg = storm['red']            # #f7768e
c.colors.messages.error.fg = storm['bg']             # #24283b
c.colors.messages.warning.bg = storm['ylw']          # #e0af68
c.colors.messages.warning.fg = storm['bg']           # #24283b

# Downloads
c.colors.downloads.bar.bg = f"{bg_color}{alpha}"     # #24283bE6 (transparent)
c.colors.downloads.start.bg = storm['mag']           # #bb9af7
c.colors.downloads.start.fg = storm['bg']            # #24283b
c.colors.downloads.stop.bg = storm['brblk']          # #565f89
c.colors.downloads.stop.fg = storm['fg']             # #c0caf5
c.colors.downloads.error.bg = storm['red']           # #f7768e
c.colors.downloads.error.fg = storm['bg']            # #24283b

# Other
c.colors.tooltip.bg = storm['bg']                    # #24283b
c.colors.webpage.bg = storm['bg']                    # #24283b

# ============================================================================
# FONTS
# ============================================================================

c.fonts.default_family = "Cascadia Code"
c.fonts.default_size = "13pt"
c.fonts.web.family.fixed = "Cascadia Code"
c.fonts.web.family.sans_serif = "Cascadia Code"
c.fonts.web.family.serif = "Cascadia Code"
c.fonts.web.family.standard = "Cascadia Code"
c.fonts.web.size.default = 20

# ============================================================================
# UI BEHAVIOR
# ============================================================================

c.tabs.show = "multiple"
c.tabs.title.format = "{audio}{current_title}"
c.tabs.padding = {'top': 5, 'bottom': 5, 'left': 9, 'right': 9}
c.tabs.indicator.width = 0  # Hide tab indicators if you don't want them
c.tabs.width = '7%'
c.auto_save.session = True

# ============================================================================
# SEARCH ENGINES
# ============================================================================

c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    '!aw': 'https://wiki.archlinux.org/?search={}',
    '!apkg': 'https://archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
    '!gh': 'https://github.com/search?o=desc&q={}&s=stars',
    '!yt': 'https://www.youtube.com/results?search_query={}',
}

c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history', 'filesystem']

# ============================================================================
# KEYBINDINGS
# ============================================================================

config.bind('=', 'cmd-set-text -s :open')
config.bind('h', 'history')
config.bind('cs', 'cmd-set-text -s :config-source')
config.bind('tH', 'config-cycle tabs.show multiple never')
config.bind('sH', 'config-cycle statusbar.show always never')
config.bind('T', 'hint links tab')
config.bind('F', 'hint links tab')  # Capital F for new tab hints
config.bind('pP', 'open -- {primary}')
config.bind('pp', 'open -- {clipboard}')
config.bind('pt', 'open -t -- {clipboard}')
config.bind('qm', 'macro-record')
config.bind('<ctrl-y>', 'spawn --userscript ytdl.sh')
config.bind('tT', 'config-cycle tabs.position top left')
config.bind('gJ', 'tab-move +')
config.bind('gK', 'tab-move -')
config.bind('gm', 'tab-move')

# Dark mode toggles
config.bind(',d', 'config-cycle -u {url:host} colors.webpage.darkmode.enabled')
config.bind(',D', 'config-cycle colors.webpage.darkmode.enabled')

# ============================================================================
# DARK MODE SETTINGS
# ============================================================================

c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'never'
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

# ============================================================================
# CONTENT SETTINGS
# ============================================================================

c.content.javascript.enabled = True
c.content.javascript.clipboard = "access"
c.content.user_stylesheets = ["~/.config/qutebrowser/styles/youtube-tweaks.css"]

# Privacy settings
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)

c.colors.messages.error.bg = f"{bg_color}{alpha}"
c.colors.messages.error.fg = f"{bg_color}{alpha}"
c.colors.messages.error.border = f"{bg_color}{alpha}"

# ============================================================================
# ADBLOCKING
# ============================================================================

c.content.blocking.enabled = True
c.content.blocking.method = 'adblock'
c.content.blocking.adblock.lists = [
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt", 
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-cookies.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-others.txt",
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/quick-fixes.txt",
]
