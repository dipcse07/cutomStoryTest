//
//  ViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 27/6/21.
//

import UIKit

class ViewController: UIViewController {

    private let storyFullScreenViewer = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(identifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchStories()
    }
    func passStories(stories:IGStories){
        storyFullScreenViewer.populateStoryProperties(stories: stories)
        self.present(storyFullScreenViewer, animated: true, completion: nil)
    }

    func fetchStories() {
        Api.shared.getStories(withPageNo: 1, pageSize: 100){ (success,error,stories) in
            DispatchQueue.main.async { [self] in
                
                if success {
                    if let stories = stories, stories.count > 0 {
                        print(stories.stories.debugDescription)

                      //  print("printing the igStories passed in storyView \n", self.storyView.igStories.stories.count)
                        passStories(stories: stories)
                    print(error)
                }
                    
            }
        }
        }
    }
}

