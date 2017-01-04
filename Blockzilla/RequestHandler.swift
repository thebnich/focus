/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

private let internalSchemes = ["http", "https", "ftp", "file", "about", "javascript", "data"]

class RequestHandler {
    func handle(request: URLRequest, alertCallback: (UIAlertController) -> ()) -> Bool {
        guard let url = request.url,
              let scheme = request.url?.scheme?.lowercased() else {
            return false
        }

        // If the URL isn't a scheme the browser can open, let the system handle it if
        // it's a scheme we want to support.
        guard internalSchemes.contains(scheme) else {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return false
            }

            let title = components.path

            switch scheme {
            case "facetime": fallthrough
            case "facetime-audio": fallthrough
            case "tel":
                let alert = RequestHandler.makeAlert(title: title, cancel: "Cancel", ok: "Call", forURL: url)
                alertCallback(alert)
            case "mailto":
                let alert = RequestHandler.makeAlert(title: title, cancel: "Cancel", ok: "Email", forURL: url)
                alertCallback(alert)
            default:
                break
            }

            return false
        }

        guard scheme == "http" || scheme == "https",
              let host = url.host?.lowercased() else {
            return true
        }

        switch host {
        case "maps.apple.com":
            let alert = RequestHandler.makeAlert(title: "Open Maps?", cancel: "Cancel", ok: "OK", forURL: url)
            alertCallback(alert)
            return false
        case "itunes.apple.com":
            let alert = RequestHandler.makeAlert(title: "Open the App Store?", cancel: "Cancel", ok: "OK", forURL: url)
            alertCallback(alert)
            return false
        default:
            return true
        }
    }

    static private func makeAlert(title: String, cancel: String, ok: String, forURL url: URL) -> UIAlertController {
        let openAction = UIAlertAction(title: ok, style: .default) { _ in
            UIApplication.shared.openURL(url)
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        alert.addAction(openAction)
        alert.preferredAction = openAction
        return alert
    }
}
