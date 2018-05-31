import fontParts

#fonts = fontParts.AllFonts()
#fonts = fontParts.AllFonts("magic")
#fonts = fontParts.AllFonts(["familyName", "styleName"])

font = fontParts.NewFont(familyName="My Family", styleName="My Style")
print(font)

font.save(path="foo/bar/name.ufo")
print(font.path)

layer = font.newLayer("My Layer 1")
print(layer)
