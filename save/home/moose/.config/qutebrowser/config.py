# linting hehe
c = c
config = config

# Load autoconfig
config.load_autoconfig(False)

# Theme & Appearance
c.colors.webpage.preferred_color_scheme = 'dark'
c.qt.highdpi = True
c.tabs.show = 'always'
c.tabs.position = 'top'
c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 8, 'right': 8}
c.statusbar.show = 'in-mode'

# Downloads
c.downloads.location.directory = '~/Downloads'

# Privacy & Security
c.content.headers.do_not_track = True
c.content.headers.accept_language = "en-US,en;q=0.9"
c.content.headers.user_agent = (
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko)"
    "{upstream_browser_key}/{upstream_browser_version_short} Safari/{webkit_version}"
)

c.content.autoplay = False
c.content.geolocation = False
c.content.desktop_capture = False
c.content.notifications.enabled = False
c.content.media.audio_capture = False
c.content.media.video_capture = False
c.content.canvas_reading = True  # <-- breaks iframes if False
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
    "translate": "https://translate.google.com/?sl=auto&tl=en&text={}&op=translate",
    "man": "https://man.archlinux.org/man/{}.en",
    "wiki": "https://en.wikipedia.org/wiki/{}",
    "dict": "https://www.dictionary.com/browse/{}",
    "jklm": "https://www.merriam-webster.com/wordfinder/classic/contains/all/-1/{}/1"  # noqa: E501
}
