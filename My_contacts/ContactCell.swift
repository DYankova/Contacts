//
//  ContactCell.swift
//  My_contacts
//
//  Created by Dilyana Yankova on 7/18/18.
//  Copyright © 2018 Dilyana Yankova. All rights reserved.
//

import UIKit

class ContactCell : UITableViewCell {
    
    var link: ViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
       //kind of cheat a bit
        let starBtn = UIButton(type: .system)
        starBtn.setImage(#imageLiteral(resourceName: "star_no_favorite"), for: .normal)
        starBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        starBtn.tintColor = .blue
        starBtn.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
        accessoryView = starBtn
    }
    @objc func handleMarkAsFavorite(){
        link?.method(cell: self) //self is the exact ContactCell
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
