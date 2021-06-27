//
//  ViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import UIKit

class ViewController: UIViewController, FullScreenSotryDelegate {
    func currentStory(story: IGStory) {
        print("this is printing from the delegate")
    }
    

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

                      //  print("printing the igStories passed in storyView \n", self.storyView.igStories.stories.count)
                        let fullStoryVC = StoryFullScreenViewer.instantiate(with: stories, handPickedStoryIndex: 0, delegate: self)
                        self.present(fullStoryVC, animated: true, completion: nil)
                    print(error)
                }
                    
            }
        }
        }
    }
}

