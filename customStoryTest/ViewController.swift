//
//  ViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import UIKit

class ViewController: UIViewController {
    
//    private let storyFullScreenViewer = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(identifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
    var stories: IGStories?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchStories()
    }
  

    func fetchStories() {
        Api.shared.getStories(withPageNo: 1, pageSize: 100){ (success,error,stories) in
            DispatchQueue.main.async { [self] in
                
                if success {
                    if let stories = stories, stories.count > 0 {
                        print(stories.stories.debugDescription)
                        self.stories = stories
                        let fullStoryVC = StoryFullVC(with: stories, handPickedStoryIndex: 0, delegate: self)

                        self.present(fullStoryVC, animated: true, completion: nil)
                    print(error)
                }
                    
            }
        }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let fullStoryVC = StoryFullVC(with: self.stories!, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
        self.present(fullStoryVC, animated: true, completion: nil)
    }
    
    
    @IBAction func b2(_ sender: UIButton) {
        
        let fullStoryVC = StoryFullVC(with: self.stories!, handPickedStoryIndex: 1, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
        self.present(fullStoryVC, animated: true, completion: nil)
    }
    
}


extension ViewController: FullScreenSotryDelegate {
    func snapDidAppear(currentSnapInProgress: IGSnap?) {
        print("current snap info ID: passed in Caller View Controller: ", currentSnapInProgress?.internalIdentifier)
    }
    
    func snapDidDisappear(previousSnap: IGSnap?) {
        print("previous snap info ID: passed in Caller View Controller: ", previousSnap?.internalIdentifier)
    }
    
    func snapWillAppear(nextSnap: IGSnap?) {
        print("next snap info ID: passed in Caller View Controller: ", nextSnap?.internalIdentifier)
    }
    
    func profileImageTapped(userInfo: IGUser?) {
        print("user info passed in Caller View Controller: ", userInfo?.name)
        
    }
    
    func snapClosed(atStroy: IGStory, forStoryIndexPath: IndexPath, forSnap: IGSnap) {
        print("snapClosed info passed in Caller View Controller: ", atStroy.group?.groupType, forStoryIndexPath, forSnap.lastUpdated )
    }
    
    func storyDidAppear(currentStoryInProgress: IGStory?) {
        print("current story info passed in Caller View Controller: ", currentStoryInProgress?.institute?.instituteName)
        
    }
    
    func storyWillAppear(nextStory: IGStory?) {
        print("next story info passed in Caller View Controller: ", nextStory?.institute?.instituteName)
    }
    
    func storyDidDisAppear(previousStory: IGStory?) {
        print("next story info passed in Caller View Controller: ", previousStory?.institute?.instituteName)
    }
    
    
 

    
}
