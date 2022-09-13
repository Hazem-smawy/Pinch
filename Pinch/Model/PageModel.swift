//
//  PageModel.swift
//  Pinch
//
//  Created by hazem smawy on 05/09/2022.
//

import Foundation

struct Page :Identifiable {
    let id:Int
    let imageName:String
}

extension Page {
    var thumbnailName:String {
        return "thumb-" + imageName
    }
}
