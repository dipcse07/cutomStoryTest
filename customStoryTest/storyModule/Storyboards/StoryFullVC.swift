//
//  StoryFullVC.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 15/7/21.
//

import UIKit

public class StoryFullVC: UIViewController {
    var onceOnly = false
    
    var igStories: IGStories!
    var delegate: FullScreenSotryDelegate?
    var storyIndex: Int!
    var previousSnap: IGSnap!
    private var stories = [IGStory]()
    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    init(with stories: IGStories, handPickedStoryIndex: Int, delegate:FullScreenSotryDelegate) {
        self.igStories = stories
        self.delegate = delegate
        self.storyIndex = handPickedStoryIndex
       
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryCollectionViewCell")
       // populateStories()
        self.stories = self.igStories.stories
    }

    func scrollAutomatically() {
        
        if let coll  = storyCollectionView{
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < stories.count - 1){
                    let indexPath1: IndexPath?
                
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                   if indexPath1!.item > 0 {
                    let prevIndex = indexPath1!.item - 1
                    delegate?.storyDidDisAppear(previousStory: stories[prevIndex] )
                    }
                    
                    delegate?.storyDidAppear(currentStoryInProgress: stories[indexPath1!.item])
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    if indexPath1!.item < stories.count - 2 {
                        delegate?.storyWillAppear(nextStory: stories[indexPath1!.item + 1])
                    }
                }
                else{
                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
//                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    
                   // self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }

}

extension StoryFullVC:  UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storyCollectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        print(indexPath.row, indexPath.item)
        cell.story = self.stories[indexPath.item]
        cell.storyIndexPath = indexPath
        cell.fullScreenStoryDelegateForCell = self
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
              let indexToScrollTo = IndexPath(item: storyIndex , section: 0)
              self.storyCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            delegate?.storyDidAppear(currentStoryInProgress: stories[indexToScrollTo.item])
              onceOnly = true
            }
    }
    
}


extension StoryFullVC:  UICollectionViewDelegate {
  
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
   
    
}

extension StoryFullVC: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension StoryFullVC: FullScreenSnapDelegate{
    func snapDidAppear(currentSnapInProgress: IGSnap?) {
        print("snap Did Appear: ", currentSnapInProgress?.lastUpdated)
        delegate?.snapDidAppear(currentSnapInProgress: currentSnapInProgress)
    }
    
    func snapWillAppear(nextSnap: IGSnap?) {
        print("snap will Appear: ", nextSnap?.lastUpdated)
        delegate?.snapWillAppear(nextSnap: nextSnap)
    }
    
    func snapDidDisappear(previousSnap: IGSnap?) {
        print("snap Did Disappear: ", previousSnap?.lastUpdated)
        if let snap = previousSnap {
            self.previousSnap = snap
            delegate?.snapDidDisappear(previousSnap: previousSnap)
        } else if self.previousSnap != nil {
            delegate?.snapDidDisappear(previousSnap: self.previousSnap)
        }
    }
    
    func profileImageTapped(userInfo: IGUser?) {
        print("ProfileUserTapped in Story Collection View Controller for Story Cell: ", userInfo?.name)
        delegate?.profileImageTapped(userInfo: userInfo)
    }
    

    
    func snapClosed(isClosed: Bool, atStroy: IGStory, forStoryIndexPath:IndexPath, forSnap: IGSnap) {
        if forStoryIndexPath.item <  self.stories.count - 1, !isClosed {
            print("Auto Scrolling to next Story Cell")
            scrollAutomatically()
        }else {
        
            print("Story CollectionViewController Dissmissed", forSnap.url)
        self.dismiss(animated: true)
            delegate?.snapClosed(atStroy: atStroy , forStoryIndexPath: forStoryIndexPath, forSnap: forSnap)
        }
       
        //delegate.snapClosed(atStroy: atStroy, forSnap: forSnap)
    }
    

    
}
