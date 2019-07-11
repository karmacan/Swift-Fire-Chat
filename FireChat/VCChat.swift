import UIKit

import Firebase
import SVProgressHUD
import ChameleonFramework

class VCChat: UIViewController, UITableViewDelegate, UITextFieldDelegate {

//  let messages = [
//    "First message body",
//    "Second message body Second message body Second message body",
//    "Third message body"
//  ]
  var messages: [MMessage] = []
  var dbMessages: DatabaseReference!
  let keyboardHeight: CGFloat = 258

  /// INIT
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }

  @IBOutlet var tvChatList: UITableView!
  @IBOutlet var tfMessage: UITextField!
  @IBOutlet var cHeight: NSLayoutConstraint!
  @IBOutlet var bSend: UIButton!
  
  /// VIEW LOAD
  override func viewDidLoad() {
    super.viewDidLoad()

    adjustTableView()

    // Setup table view
    tvChatList.delegate = self // for UITableViewDelegate
    tvChatList.dataSource = self
    // Become reciever
    tfMessage.delegate = self
    
    // REGESTER XIB
    tvChatList.register(
      UINib(nibName: "Message"/*.xib*/, bundle: nil),
      forCellReuseIdentifier: "MessageCell"
    )
    
    // Hide keyboard
    let gestureTap = UITapGestureRecognizer(
      target: self,
      action: #selector(textFieldEndEditing)
    )
    tvChatList.addGestureRecognizer(gestureTap)
    
    let delay = 0.2 /*sec*/
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      // Exequte after delay
      SVProgressHUD.show()
    }
    
    // Reference db
    dbMessages = Database.database().reference().child("Messages")
    //
    dbMessages?.observeSingleEvent(of: .value, with: ifObservedNull)
    // Retrive all and observe new
    dbMessages.observe(.childAdded, with: forObservedMessage) // async
  }
  
  /// ADJUST TABLE VIEW
  func adjustTableView() {
    // Add background
    let backgroundImage = UIImage(named: "w-charcoal-1350x2400")
    let backgroundView = UIImageView(image: backgroundImage)
    backgroundView.contentMode = .scaleAspectFill
    tvChatList.backgroundView = backgroundView
    // Remove separator lines
    tvChatList.separatorStyle = .none
    // Add bottom padding
    tvChatList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0);
  }
  
  /// FOR OBSERVED MESSAGE
  func forObservedMessage(_ snapshot: DataSnapshot) {
    let observedMessage = snapshot.value as! [String: Any]
    print("Observed message: \n\(observedMessage)")
    let senderEmail = observedMessage["sender_email"] as! String
    let messageBody = observedMessage["message_body"] as! String
    //print("Observed message: \n\(senderEmail) \n\(messageBody)")
    let message = MMessage(senderEmail, messageBody)
    messages.append(message)
    
    SVProgressHUD.dismiss()
    
    tvChatList.reloadData()
  }
  func ifObservedNull(_ snapshot: DataSnapshot) {
    // Cast will return nil if child("Messages") is empty so snapshot will be NSNull
    if (snapshot.value as? [String: Any]) == nil {
      SVProgressHUD.dismiss()
    }
  }
  
  /// ON LOG OUT CLICKED
  @IBAction func onLogoutClicked(_ sender: Any?) {
    do {
      try Auth.auth().signOut()
      // Go to root (welcome)
      navigationController?.popToRootViewController(animated: true)
    }
    catch let error {
      print("Logout failure! \n\(error)")
    }
  }
  
  /// ON TEST FIELD EDITING
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Animate
    UIView.animate(withDuration: 0.5 /*sec*/) /*cb*/ {
      // Increase height to free space fore keybard
      self.cHeight.constant += self.keyboardHeight
      // Redraw view
      self.view.layoutIfNeeded()
    }
  }
  @objc func textFieldEndEditing() {
    tfMessage.endEditing(true) // triggers textFieldDidEndEditing()
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    // Animate
    UIView.animate(withDuration: 0.5 /*sec*/) /*cb*/ {
      // Increase height to free space fore keybard
      self.cHeight.constant -= self.keyboardHeight
      // Redraw view
      self.view.layoutIfNeeded()
    }
  }
  
  ////////////////////////////////////////
  /// ON SEND CLICKED
  
  @IBAction func onSendClicked(_ sender: Any?) {
    // Collapse keyboard area
    textFieldEndEditing()
    // Block send button (while sending)
    bSend.isEnabled = false
    // Compose message dict
    let message: [String: Any] = [
      "sender_email": Auth.auth().currentUser?.email,                                     //
      "message_body": tfMessage.text                                                      //
    ]
    sendMessage(message)
  }
  
  /// SEND TO DB
  func sendMessage(_ message: [String : Any]) {
    dbMessages.childByAutoId().setValue(message) {
      (error, reference) in
      if error != nil {
        print("Message sending failure! \n\(error!)")
      }
      else {
        print("Message sending success!")
        self.tfMessage.text = ""
        self.bSend.isEnabled = true
      }
    }
  }
  
  /// BLOCK CELLS FROM SELECTION
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}

extension VCChat: UITableViewDataSource {

  ////////////////////////////////////////
  /// PROVIDE CELL
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
    
    let cell = tvChatList.dequeueReusableCell(
      withIdentifier: "MessageCell",
      for: indexPath
    ) as! TVCMessage
    
    cell.backgroundColor = .clear
    
    cell.lUsername.text = messages[indexPath.row].senderEmail
    cell.lBody.text = messages[indexPath.row].messgeBody
    cell.ivAvatar.image = UIImage(named: "icon-user-circle")
    
    if messages[indexPath.row].senderEmail == Auth.auth().currentUser?.email as! String {
      cell.lUsername.text = "Me"
      cell.lUsername.textColor = UIColor.flatWhiteColorDark()
      cell.vBackground.backgroundColor = UIColor.flatBlue()
    }
  
    return cell
  }
  
  /// PROVIDE COUNT
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int {
    
    return messages.count
  }
  
}
