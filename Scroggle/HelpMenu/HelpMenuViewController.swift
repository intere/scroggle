//
//  HelpMenuViewController.swift
//  Scroggle
//
//  Created by Eric Internicola on 10/14/18.
//  Copyright © 2018 Eric Internicola. All rights reserved.
//

import MessageUI
import UIKit

class HelpMenuViewController: ChalkboardViewController {

    var emailMethod: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func loadFromStoryboard() -> HelpMenuViewController {
        return UIStoryboard(name: "Help", bundle: nil)
            .instantiateViewController(withIdentifier: "HelpMenuViewController") as! HelpMenuViewController
        // swiftlint:disable:previous force_cast
    }

}

// MARK: - MenuBuilding

extension HelpMenuViewController: MenuBuilding {

    func buildMenu() -> MenuInfo? {
        return MenuInfo(title: "Help", buttons: [
            ButtonCellInfo(title: "General Help", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                let url = "https://intere.github.io/scroggle-support/#/help"
                self?.navigationController?.pushViewController(
                    WebViewController.loadFromStoryboard(url: url), animated: true)
            }),
            ButtonCellInfo(title: "Goals + Rules", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                let url = "https://intere.github.io/scroggle-support/#/rules"
                self?.navigationController?.pushViewController(
                    WebViewController.loadFromStoryboard(url: url), animated: true)
            }),
            ButtonCellInfo(title: "Email support", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                self?.emailSupport()
            }),
            ButtonCellInfo(title: "Report a bug", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                self?.emailBugReport()
            }),
            ButtonCellInfo(title: "About Scroggle", action: { [weak self] in
                SoundProvider.instance.playMenuSelectionSound()
                // TODO: Implement me
            })

        ])
    }

}

// MARK: - MFMailComposeViewControllerDelegate

extension HelpMenuViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        let emailMethod = self.emailMethod ?? "Unknown"

        switch result {
        case .cancelled:
            AnalyticsProvider.instance.composeEmailCompleted(completionResult: "Cancelled", emailType: emailMethod)
        case .failed:
            AnalyticsProvider.instance.composeEmailCompleted(completionResult: "Failed", emailType: emailMethod)
        case .saved:
            AnalyticsProvider.instance.composeEmailCompleted(completionResult: "Saved", emailType: emailMethod)
        case .sent:
            AnalyticsProvider.instance.composeEmailCompleted(completionResult: "Sent", emailType: emailMethod)
        }
        controller.dismiss(animated: true, completion: nil)
        self.emailMethod = nil
    }

}

// MARK: - Implementation

extension HelpMenuViewController {

    func emailBugReport() {
        emailMethod = "BugReport"
        configureAndShowComposeEmail(recipient: "support+scroggle-bug@internicola.us",
                                     subject: "Bug Report", body: buildBugReportBody())
    }

    func emailSupport() {
        emailMethod = "Support"
        configureAndShowComposeEmail(recipient: "support+scroggle@internicola.us",
                                     subject: "Support Request", body: buildSupportEmailBody())
    }

    func configureAndShowComposeEmail(recipient: String, subject: String, body: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients([recipient])
            composeVC.setSubject(subject)
            composeVC.setMessageBody(body, isHTML: false)

            // Present the view controller modally.
            present(composeVC, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email",
                                      message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func buildBugReportBody() -> String {
        var body = "I've found a bug with Scroggle."
        body = "\(body)\n\nWhat I was doing when the bug happened:"
        body = "\(body)\n\nWhat should have happened:"
        body = "\(body)\n\nHow you can reproduce it (if applicable):"
        body = "\(body)\n\n\n\n--------------------------------------------------------\n"
        body = "\(body)\(buildSupportInformation())"

        return body
    }

    func buildSupportEmailBody() -> String {
        var body = "I'm having issues with Scroggle.  Could you please Help?"
        body = "\(body)\n\nProblem Description:"
        body = "\(body)\n\n\n\n--------------------------------------------------------\n"
        body = "\(body)\(buildSupportInformation())"

        return body
    }

    func buildSupportInformation() -> String {
        var body = "Support Information:"
        // TODO: Fix me when GameCenterProvider is implemented
//        if let playerId = GameCenterProvider.instance.localPlayer.playerID, GameCenterProvider.instance.loggedIn {
//            body = "\(body)\nGame Center User ID: \(playerId)"
//        } else {
            body = "\(body)\nNot Logged into Game Center"
//        }

        let version = ConfigurationProvider.instance.appVersion
        body = "\(body)\nVersion: \(version)"
        let buildNumber = ConfigurationProvider.instance.appBuildNumber
        body = "\(body)\nBuild: \(buildNumber)"

        return body
    }
}
