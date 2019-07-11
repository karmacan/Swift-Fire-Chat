import UIKit

import Firebase

/// SEGUES
/// Present Modally -> Show view
/// Show -> Show view and make it part of navigation stack

/*
CONTENT HUGGING
Sets the priority with which a view resists being made larger than its intrinsic size.
Setting a larger value to this priority indicates that we don’t want the view to grow larger than its content.
COMPRESSION RESISTANCE
Sets the priority with which a view resists being made smaller than its intrinsic size.
Setting a higher value means that we don’t want the view to shrink smaller than the intrinsic content size.
*/

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

