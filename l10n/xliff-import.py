#!/usr/bin/env python

#
# xliff-import.py xcodeproj-path l10n-path
#
#  Import all locales that are present in the l10n directory. We use xcodebuild
#  to import and mod_pbxproj.py to update the project.
#
# Example:
#
#  cd firefox-ios
#  ./xliff-import.py Client.xcodeproj ../firefox-ios-l10n
#

import glob
import os
import shutil
import subprocess
import sys

def available_locales(l10n_path):
    return os.listdir(l10n_path)

if __name__ == "__main__":
    project_path = sys.argv[1]
    l10n_path = sys.argv[2]

    for locale in available_locales(l10n_path):
        if locale == "en-US":
            continue
        command = [
            "xcodebuild",
            "-importLocalizations",
            "-localizationPath", "%s/%s/focus-ios.xliff" % (l10n_path, locale),
            "-project", project_path
        ]

        print "Import '%s' from '%s/%s/focus-ios.xliff'" % (locale, l10n_path, locale)
        subprocess.call(command)
