//
//  TVCMessage.swift
//  FireChat
//
//  Created by Admin on 7/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class TVCMessage: UITableViewCell {

  @IBOutlet var lUsername: UILabel!
  @IBOutlet var lBody: UILabel!
  @IBOutlet var ivAvatar: UIImageView!
  @IBOutlet var vBackground: UIView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
