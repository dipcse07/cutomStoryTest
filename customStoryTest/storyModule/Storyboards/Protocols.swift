//
//  Protocols.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import Foundation
protocol FullScreenSotryDelegate {
    func currentStory(story: IGStory)
    func profileImageTapped(userInfo: IGUser)
    func storiesClosed()
}
