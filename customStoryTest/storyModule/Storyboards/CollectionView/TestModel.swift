//
//  TestModel.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 28/6/21.
//

import Foundation
import UIKit
struct Stories {
    let stories: [Story]
}

struct Story {
    var snaps: [Snap]
}

struct Snap {
    var image: UIImage
}
