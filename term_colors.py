class Base(object):
    foreground = 30
    background = 40

class Color(object):
    black = 0
    red = 1
    green = 2
    yellow = 3
    blue = 4
    magenta = 5
    cyan = 6
    white = 7

class Style(object):
    bright = 1
    underline = 4
    italic = 3
    negative = 7

def color(s, color_, base=Base.foreground, styles=[]):
    style = ""
    for style_ in styles:
        style += str(style_) + ";"
    style += str(base + color_) + "m"
    return "\x00[" + style + "\x00[0m"
