import UIKit

import Firebase
import SVProgressHUD

class VCLogin: UIViewController {

  @IBOutlet var tfEmail: UITextField!
  @IBOutlet var tfPassword: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  @IBAction func onCancelClicked(_ sender: Any?) {
    navigationController?.popViewController(animated: true)
  }

  /// LOG
  @IBAction func onLogClicked() {
  
//    let closeAfter: (AuthDataResult?, Error?) -> Void = {
//      result, error in
//      self.afterSignInCompletion(result, error)
//    }
  
    SVProgressHUD.show() // show progress animation
  
    Auth.auth().signIn(
      withEmail: tfEmail.text ?? "",
      password: tfPassword.text ?? "",
      completion: afterSignInCompletion
    )
  
  }
  
  /// AFTER SIGN IN COMPLETION (go to chat)
  func afterSignInCompletion(_ result: AuthDataResult?, _ error: Error?) {
    if error != nil {
      print("Login failure! \n\(error!)")
      
      SVProgressHUD.showError(withStatus: error?.localizedDescription)
      let delay = 2.0 /*sec*/
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        // Exequte after delay
        SVProgressHUD.dismiss()
      }
    
    }
    else {
      print("Login success!")
      
      SVProgressHUD.dismiss()
      
      performSegue(
        withIdentifier: "SegueToChat",
        sender: nil
      )
    }
  }

}
