# linting hehe
c = c
config = config

# Load autoconfig
config.load_autoconfig(False)

# Theme & Appearance
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'dark'
c.qt.highdpi = True
c.tabs.show = 'always'
c.tabs.position = 'top'
c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 8, 'right': 8}
c.statusbar.show = 'in-mode'

# Downloads
c.downloads.location.directory = '~/Downloads'

# Privacy & Security
c.content.headers.accept_language = "en-US,en;q=0.9"
c.content.headers.user_agent = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    "AppleWebKit/537.36 (KHTML, like Gecko)"
    "Chrome/137.0.0.0 Safari/537.36"
)

# do_not_track break youtube
# c.content.headers.do_not_track = True

c.content.autoplay = False
c.content.geolocation = False
c.content.desktop_capture = False
c.content.notifications.enabled = False
c.content.media.audio_capture = False
c.content.media.video_capture = False
c.content.canvas_reading = False  # <-- breaks iframes
c.content.webgl = False
c.content.pdfjs = True
c.content.cookies.accept = 'no-3rdparty'
c.content.blocking.method = 'both'
c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt'
]

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "wiki": "https://en.wikipedia.org/wiki/{}",
    "dict": "https://www.dictionary.com/browse/{}",
    "jklm": "https://www.merriam-webster.com/wordfinder/classic/contains/all/-1/{}/1"  # noqa: E501
}
