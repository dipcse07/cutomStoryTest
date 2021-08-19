//
//  ViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import UIKit
import IFStory

class ViewController: UIViewController {
    
//    private let storyFullScreenViewer = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(identifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
    var stories: IFStories?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchStories()
    }
  

    func fetchStories() {
        Api.shared.getStories(withPageNo: 1, pageSize: 100){ (success,error,stories) in
            DispatchQueue.main.async { [self] in
                
                if success {
                    if let stories = stories, stories.totalStoryCount > 0 {
                        print(stories.stories.debugDescription)
                        self.stories = stories
                        
                        let fullStoryVC = StoryFullVC(with: stories, handPickedStoryIndex: 0, delegate: self)
                        fullStoryVC.setVideoOrImageView(top: 15, left: 16, right: 16, bottom: 16, cornerRadius: 25)
                        self.present(fullStoryVC, animated: true, completion: nil)
                    print(error)
                }
                    
            }
        }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let fullStoryVC = StoryFullVC(with: self.stories!, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
        fullStoryVC.setVideoOrImageView(top: 15, left: 16, right: 16, bottom: 16, cornerRadius: 25)
        self.present(fullStoryVC, animated: true, completion: nil)
    }
    
    
    @IBAction func b2(_ sender: UIButton) {
        
        let fullStoryVC = StoryFullVC(with: self.stories!, handPickedStoryIndex: 1, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
        fullStoryVC.setVideoOrImageView(top: 15, left: 16, right: 16, bottom: 16, cornerRadius: 25)
        self.present(fullStoryVC, animated: true, completion: nil)
    }
    
}


extension ViewController: FullScreenSotryDelegate {
    func snapDidAppear(currentSnapInProgress: IFSnap?) {
        print("current snap info ID: passed in Caller View Controller: ", currentSnapInProgress?.storySnapIdentifier)
    }
    
    func snapDidDisappear(previousSnap: IFSnap?) {
        print("previous snap info ID: passed in Caller View Controller: ", previousSnap?.storySnapIdentifier)
    }
    
    func snapWillAppear(nextSnap: IFSnap?) {
        print("next snap info ID: passed in Caller View Controller: ", nextSnap?.storySnapIdentifier)
    }
    
    func profileImageTapped(userInfo: IFUser?) {
        print("user info passed in Caller View Controller: ", userInfo?.userName)
        
    }
    
    func snapClosed(atStroy: IFSingleStory, forStoryIndexPath: IndexPath, forSnap: IFSnap) {
        print("snapClosed info passed in Caller View Controller: ", atStroy.group?.groupType, forStoryIndexPath, forSnap.lastUpdated )
    }
    
    func storyDidAppear(currentStoryInProgress: IFSingleStory?) {
        print("current story info passed in Caller View Controller: ", currentStoryInProgress?.institute?.instituteName)
        
    }
    
    func storyWillAppear(nextStory: IFSingleStory?) {
        print("next story info passed in Caller View Controller: ", nextStory?.institute?.instituteName)
    }
    
    func storyDidDisAppear(previousStory: IFSingleStory?) {
        print("next story info passed in Caller View Controller: ", previousStory?.institute?.instituteName)
    }
    
    
 

    
}
