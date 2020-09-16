import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard
            let text = textView.text,
            let sharedDefaults = UserDefaults(
                suiteName: "group.com.jesterix.RecipeBook") else {
                    return
        }
        
        sharedDefaults.set(text, forKey: "shareTask")

        guard let url = URL(string: "RecipeBookAppUrl://") else { return }

//        dismiss(animated: false) {
//
//        }
        _ = self.openURL(url)

        self.extensionContext!.completeRequest(
            returningItems: [],
            completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
