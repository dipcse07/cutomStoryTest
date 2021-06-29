//
//  Protocols.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import Foundation

protocol FullScreenCallerDelegate {
    func currentStoryAndSnap(story: IGStory?, snap: IGSnap?)
    func profileImageTapped(userInfo: IGUser?)
}
protocol FullScreenSotryDelegate:FullScreenCallerDelegate {
   
    func storiesClosed()
    func nextStory()
}
