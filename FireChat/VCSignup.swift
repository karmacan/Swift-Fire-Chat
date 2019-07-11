import UIKit

import Firebase
import SVProgressHUD

class VCSignup: UIViewController {

  @IBOutlet var tfEmail: UITextField!
  @IBOutlet var tfPassword: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  @IBAction func onCancelClicked(_ sender: Any?) {
    navigationController?.popViewController(animated: true)
  }
  
  /// SING
  @IBAction func onSignClicked(_ sender: Any?) {
  
    SVProgressHUD.show()
  
    // Auth user in firebase
    Auth.auth().createUser(
      withEmail: tfEmail.text!,
      password: tfPassword.text!,
      completion: afterCreateUserCompletion
    )
  }
  
  /// AFTER CREATE USER COMPLETION (go to chat)
  func afterCreateUserCompletion(_ user: AuthDataResult?, _ error: Error?) {
    if error != nil {
      print("Signup failure! \n\(error!)")
      
      SVProgressHUD.showError(withStatus: error?.localizedDescription)
      let delay = 2.0 /*sec*/
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        // Exequte after delay
        SVProgressHUD.dismiss()
      }
      
    }
    else {
      print("Signup success!")
      
      SVProgressHUD.dismiss()
      
      performSegue(
        withIdentifier: "SegueToChat",
        sender: nil
      )
    }
  }

}
