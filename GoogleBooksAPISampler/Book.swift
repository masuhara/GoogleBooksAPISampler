//
//  Book.swift
//  GoogleBooksAPISampler
//
//  Created by Masuhara on 2018/05/30.
//  Copyright © 2018年 Ylab, Inc. All rights reserved.
//

import UIKit

struct Book {
    var title: String
    var imagePath: String?
    var author: String?
    
    init(title: String) {
        self.title = title
    }
}
