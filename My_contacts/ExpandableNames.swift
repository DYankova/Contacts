//
//  ExpandableNames.swift
//  My_contacts
//
//  Created by Dilyana Yankova on 7/18/18.
//  Copyright © 2018 Dilyana Yankova. All rights reserved.
//

import Foundation
import Contacts //API

struct ExpandlableNames {
    
    var isExpanded: Bool
    var names: [FavoritableContact]
    
}


struct FavoritableContact {
//    let name: String
//    let phoneNumber: String
//    let address: String
    let contact : CNContact
    var hasFavorited: Bool
}
