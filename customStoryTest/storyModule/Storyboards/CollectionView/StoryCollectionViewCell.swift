//
//  StoryCollectionViewCell.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 28/6/21.
//

import UIKit
import Kingfisher

class StoryCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // self.setupViewDidLoad()
        self.setupViewDidLoad()
        
    }
    public var story: IFSingleStory! {
        didSet{
            self.setupViewWillAppear()
            print("story count after Passing story",story.snapsInSingleStory?.count)
        }
    }
    
    @IBOutlet var closeButton: UIButton! {
        didSet {
            self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet var progressViewHolder: UIView!
    
    @IBOutlet var topTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet var storyImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var leftIconImageView: UIImageView!
    @IBOutlet var rightIconImageView: UIImageView!
    
    @IBOutlet var countLabel: UILabel!
    
    
    
    
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            self.nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        }
    }
    @IBOutlet var prevButton: UIButton! {
        didSet {
            self.prevButton.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        }
        
    }
    
    private var snapIndex = 0
    private var currentSnapIndex = 0
    public var igStories: IFStories!
    private var snapCount = 0
    //  private var stories = [IGStory]()
    private var nextSnapIndex = 0
    public var storyIndexPath: IndexPath!
    private var firstUnseenSnapShowed = false

    private var progressTimer = Timer()
    private var automaticDissappearAfterSeconds = 5.0
    private var timerProgressStartAt = 0.0
    private var progressRate = 0.0
    private var topProgressViews = [UIProgressView]()
    public var showBlurEffectOnFullScreenView = true
    private let pangestureVelocity:CGFloat = 1000
    var fullScreenStoryDelegateForCell: FullScreenSnapDelegate?
    
    
    
    
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    
    private func setupViewDidLoad() {
        //self.stories = igStories.stories
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.50
        //self.storyImageView.layer.cornerRadius = 20.0
        self.storyImageView.backgroundColor = .black
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        fullScreenStoryDelegateForCell?.profileImageTapped(userInfo: story.user)
    }
    
    private func setupViewWillAppear() {
        
        self.avatarImageView.transform = .init(scaleX: 0.50, y: 0.50)
        self.topTitleLabel.transform = .init(scaleX: 1, y: 0.85)
        
        self.progressRate = automaticDissappearAfterSeconds/1000
        
        self.topTitleLabel.text = story.user.userName
        
        if let storySnaps = story.snapsInSingleStory, !story!.isSeen {
            var snapIndexCount = 0
            for storySnap in storySnaps {
                if !storySnap.isSeen{
                    snapIndex = snapIndexCount
                    print("current snap index in timer for set View will appear: ", self.snapIndex)
                    let singleStoryImage = storySnap.storySnapUrl
                    self.storyImageView.kf.indicatorType = .activity
                    self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil, completionHandler:  {  (_) in
                        self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                        self.initProgressViews()
                        self.initTimerProgress()
                        
                    })
                    firstUnseenSnapShowed = true
                   // self.snapIndex = self.snapIndex + 1
                    
                } else {}
                if firstUnseenSnapShowed {
                    break
                }else {
                    print("snap count increasing in set view will appear: ")
                    snapIndexCount = snapIndexCount + 1
                }
                
                
            }
        } else {
            if let storySnap = story.snapsInSingleStory?.first{
                let singleStoryImage  = storySnap.storySnapUrl
                self.storyImageView.kf.indicatorType = .activity
                self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil) { (_) in
                    self.initProgressViews()
                    self.initTimerProgress()
                    self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                }
            }
        }
        
        let avatarImageLink = story.user.userProfilePicture
        //print("avatar image: ", avatarImageLink)
        self.storyImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: URL(string: avatarImageLink), placeholder:  nil , options: nil) { (_) in
            
        }
        self.timeLabel.text = story.lastUpdated

        self.timerProgressStartAt = 0.0
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.transform = .init(scaleX: 1.25, y: 1.25)
            self.topTitleLabel.transform = .identity
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.avatarImageView.transform = .identity
                //self.topTitleLabel.transform = .identity
            }
        }
        

        
    }
    
    
    private func initProgressViews() {
        
        for subViews in self.progressViewHolder.subviews {
            subViews.removeFromSuperview()
        }
        self.topProgressViews.removeAll()
        
        let stackView   = UIStackView()
        stackView.axis  = .horizontal
        stackView.contentMode = .scaleAspectFill
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing   = 8.0
        stackView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-40, height: 6)
        
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        let snaps = story.snapsInSingleStory
        
        for _ in 0..<snaps!.count {
            let progressView = UIProgressView()
            progressView.tintColor = .white
            progressView.progress = 0.0
            progressView.contentMode = .scaleAspectFill
            
            stackView.addArrangedSubview(progressView)
            self.topProgressViews.append(progressView)
        }
        self.progressViewHolder.addSubview(stackView)
    }
    
    
    
    private func updateSnap(index: Int) {
        if let snaps = story.snapsInSingleStory {
            if index > 0 {
                self.fullScreenStoryDelegateForCell?.snapDidDisappear(previousSnap: snaps[index - 1])
            }
        let storySnapUrl = snaps[index].storySnapUrl
        
        
        self.storyImageView.kf.setImage(with: URL(string: storySnapUrl), placeholder:  nil , options: nil) { (_) in
            self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: snaps[index] )
        }
            self.currentSnapIndex = index
           // self.snapIndex = self.snapIndex + 1
            let nextSnapIndex = index + 1
            if nextSnapIndex < snaps.count {
                fullScreenStoryDelegateForCell?.snapWillAppear(nextSnap: snaps[nextSnapIndex])
            }
            
    }else {
        print("there is no snap to show in current snap or update the story")
        }
    }
    
    
    
    
    @objc func closeButtonAction() {
        self.progressTimer.invalidate()
        fullScreenStoryDelegateForCell?.snapClosed(isClosed:true, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: story.snapsInSingleStory![self.currentSnapIndex])
        
    }
    
    @objc func nextAction() {
        
        let snapsInCurrentStory = story.snapsInSingleStory
        print("current snap for next Acction: ", self.snapIndex)
            if self.snapIndex < snapsInCurrentStory!.count{
                
                print("current snap Index: ", self.snapIndex)
                self.topProgressViews[snapIndex].progress = 1.0
                
                //
                self.timerProgressStartAt = 0.0
                self.timerProgressStartAt += self.progressRate
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
               
                
            }
            else {
                self.progressTimer.invalidate()
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snapsInSingleStory?.last)!)
                print("going to next story")
                //                UIView.animate(withDuration: 0.2) {
                //                    self.setupViewWillAppear()
                //                }
          }
            
        }
//        else {
//            if self.snapIndex < imagesInCurrentStory!.count-1 {
//
//            }
//            else {
//                currentViewingStoryIndex = 0
//               // self.progressTimer.invalidate()
//                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snapsInSingleStory?.last)!)
//                print("going to next story")
//
//            }
//
//        }

    
    
    @objc func prevAction() {
        
            if self.snapIndex > 0 {
                self.topProgressViews[snapIndex].progress = 0.0
                self.snapIndex -= 1
                self.topProgressViews[snapIndex].progress = 0.0
                self.timerProgressStartAt = 0.0
                
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.snapIndex = 0
                self.timerProgressStartAt = 0.0
                //                UIView.animate(withDuration: 0.2) {
                //                    self.setupViewWillAppear()
                //                }
            }
            
            
    
    }
    
    
    
    
    private func initTimerProgress() {
        
        self.progressTimer.invalidate()
        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(timerProgressAction), userInfo: nil, repeats: true)
        self.progressTimer.fire()
    }
    
    
    
    @objc func timerProgressAction() {
        //self.countLabel.text = "\(currentViewingStoryIndex+1)\n\(storyImageIndex+1)"
        if timerProgressStartAt > 1.0 {
            //self.closeButtonAction()
            let snapsInCurrentStory = story.snapsInSingleStory
            print("snaps In current sotry for timer: ", snapsInCurrentStory?.count)
            
            if self.snapIndex < snapsInCurrentStory!.count {
                print("snap In current Story for timer: ", self.snapIndex)
                
                self.timerProgressStartAt = 0.0
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
                self.snapIndex = snapIndex + 1
               
            }
            else {
               
                for progressView in topProgressViews {
                    progressView.progress = 0.0
                }
                
                self.initProgressViews()
                print("going Next Action from timer")
               self.nextAction()
                
            }
            
        }
        else {
            if snapIndex < topProgressViews.count {
                self.topProgressViews[snapIndex].progress = Float(timerProgressStartAt)
                self.timerProgressStartAt += self.progressRate
            }
            
            
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Finger touched!")
            self.progressTimer.invalidate()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("finger is not touching.")
            self.initTimerProgress()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Touch Move")
            self.progressTimer.invalidate()
        }
    }
    
    
}
