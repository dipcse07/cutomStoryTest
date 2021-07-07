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
                        let fullStoryVC = StoryCollectionViewController.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
                        self.present(fullStoryVC, animated: true, completion: nil)
                    print(error)
                }
                    
            }
        }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let fullStoryVC = StoryCollectionViewController.instantiate(with: self.stories!, handPickedStoryIndex: 0, delegate: self)//StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
        self.present(fullStoryVC, animated: true, completion: nil)
    }
    
}


extension ViewController: FullScreenSotryDelegate {
    func storyDidAppear(currentStoryInProgress: IGStory?) {
        
    }
    
    func storyWillAppear(nextStory: IGStory?) {
        
    }
    
    func storyDidDisAppear(previousStory: IGStory?) {
        
    }
    


    
}
