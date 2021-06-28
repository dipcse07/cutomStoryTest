//
//  StoryCollectionViewController.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 28/6/21.
//

import UIKit

class StoryCollectionViewController: UIViewController{
    
    var onceOnly = false
    
    internal static func instantiate(with stories: IGStories, handPickedStoryIndex: Int, delegate:FullScreenSotryDelegate) -> StoryCollectionViewController {

        let vc = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(withIdentifier: "StoryCollectionViewController") as! StoryCollectionViewController
        vc.igStories = stories
        vc.delegate = delegate
        vc.storyIndex = handPickedStoryIndex
        
        return vc
    }
    var igStories: IGStories!
    var delegate: FullScreenSotryDelegate?
    var storyIndex: Int!
    var stories = [IGStory]()
    
    @IBOutlet weak var storyCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storyCollectionView.dataSource = self
        storyCollectionView.delegate = self
        storyCollectionView.register(UINib(nibName: "StoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoryCollectionViewCell")
       // populateStories()
        self.stories = self.igStories.stories
    }
    
//    func populateStories (){
//
//        snaps = [Snap(image: UIImage(named: "1")!),Snap(image: UIImage(named: "2")!)]
//        stories.append(Story(snaps: snaps))
//        snaps = [Snap(image: UIImage(named: "3")!),Snap(image: UIImage(named: "1")!)]
//        stories.append(Story(snaps: snaps))
//    }
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollAutomatically() {
        
        if let coll  = storyCollectionView{
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < stories.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
//                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
//                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }

}

extension StoryCollectionViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storyCollectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        print(indexPath.row, indexPath.item)
        cell.stories = self.stories[indexPath.item]
        cell.fullScreenStoryDelegateForCell = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !onceOnly {
              let indexToScrollTo = IndexPath(item: 0 , section: storyIndex)
              self.storyCollectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
              onceOnly = true
            }
    }
    
}


extension StoryCollectionViewController:  UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
   
    
}

extension StoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension StoryCollectionViewController: FullScreenSotryDelegate{
  
    
    func currentStoryAndSnap(story: IGStory?, snap:IGSnap?) {
        print("from collection viewController current story")
    }
    
    func profileImageTapped(userInfo: IGUser?) {
        print("from collection viewController user tapped")
    }
    
    func storiesClosed() {
       // self.dismiss(animated: true, completion: nil)
        print("from collection viewController close button tapped")
        self.dismiss(animated: true, completion:nil)
    }
    
    func nextStory() {
        scrollAutomatically()
        print("from collection viewController next story tapped")
    }
    
}
