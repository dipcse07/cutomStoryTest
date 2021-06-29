//
//  ViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import UIKit

class ViewController: UIViewController {
    
//    private let storyFullScreenViewer = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(identifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
    
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
                        
                        let fullStoryVC = StoryCollectionViewController.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
                        self.present(fullStoryVC, animated: true, completion: nil)
                    print(error)
                }
                    
            }
        }
        }
    }
}


extension ViewController: FullScreenCallerDelegate {

    
  
    
    func currentStoryAndSnap(story: IGStory?, snap:IGSnap?) {
        print("this is printing from the delegate", story?.lastUpdated)
    }
    func profileImageTapped(userInfo: IGUser?) {
        print("current userName: ", userInfo?.name)
        print("current userProfileImage: ", userInfo?.picture)
    }
    
  
}
