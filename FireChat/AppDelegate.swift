import UIKit

import Firebase

/// SEGUES
/// Present Modally == Show view
/// Show == Show view and make it part of navigation stack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    /// CONNECT FIREBASE
    FirebaseApp.configure()
    /// Make test store in db
    //let db = Database.database().reference()
    //db.setValue("Test save!")
    
    return true
  }

}

