//
//  Protocols.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import Foundation

protocol FullScreenSnapDelegate {
   // func currentStoryAndSnap(story: IGStory?, snap: IGSnap?)
    func snapDidAppear(currentSnapInProgress:IGSnap?)
    func snapWillAppear(nextSnap: IGSnap?)
    //func snapWillDisappear()
    func snapDidDisappear(previousSnap: IGSnap?)
    
    func profileImageTapped(userInfo: IGUser?)
    
    func snapClosed(atStroy: IGStory, forSnap: IGSnap)
    
    func nextStory()
    
}
protocol FullScreenSotryDelegate {
    
    func storyDidAppear(currentStoryInProgress: IGStory?)
    func storyWillAppear(nextStory: IGStory?)
    func storyDidDisAppear(previousStory: IGStory?)

    
}
