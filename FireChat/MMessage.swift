import Foundation

class MMessage {
  var senderEmail: String = ""
  var messgeBody: String = ""
  init(_ senderEmail: String, _ messgeBody: String) {
    self.senderEmail = senderEmail
    self.messgeBody = messgeBody
  }
}
