#!/usr/bin/env python

#
# xliff-export.py xcodeproj-path l10n-path
#
#  Export all locales that are present in the l10n directory. We use xcodebuild
#  to export and write to l10n-directory/$locale/firefox-ios.xliff so that it
#  can be easily imported into Git (which is a manual step).
#
# Example:
#
#  cd firefox-ios
#  ./xliff-export.py Client.xcodeproj ../firefox-ios-l10n
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
        command = [
            "xcodebuild",
            "-exportLocalizations",
            "-localizationPath", "/tmp/xliff",
            "-project", project_path,
            "-exportLanguage", locale
        ]

        print "Exporting '%s' to '/tmp/xliff/%s.xliff'" % (locale, locale)
        subprocess.call(command)

        src_path = "/tmp/xliff/%s.xliff" % locale
        dst_path = "%s/%s/focus-ios.xliff" % (l10n_path, locale)
        print "Copying '%s' to '%s'" % (src_path, dst_path)
        shutil.copy(src_path, dst_path)
