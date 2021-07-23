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
         
            setupViewWillAppear()
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
    public var storyIndexPath: IndexPath!
    private var firstUnseenSnapShowed = false

//    private var progressTimer = Timer()
//    private var automaticDissappearAfterSeconds = 5.0
//    private var timerProgressStartAt = 0.0
//    private var progressRate = 0.0
    private var topProgressViews = [UIProgressView]()
    public var showBlurEffectOnFullScreenView = true
    private let pangestureVelocity:CGFloat = 1000
    var fullScreenStoryDelegateForCell: FullScreenSnapDelegate?

    
    private func setupViewDidLoad() {
        //self.stories = igStories.stories
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.50
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
        self.initProgressViews()
        self.avatarImageView.transform = .init(scaleX: 0.50, y: 0.50)
        self.topTitleLabel.transform = .init(scaleX: 1, y: 0.85)
        
       // self.progressRate = automaticDissappearAfterSeconds/1000
        
        self.topTitleLabel.text = story.user.userName
        
        if let storySnaps = story.snapsInSingleStory, !story!.isSeen {
            var snapIndexCount = 0
            for storySnap in storySnaps {
                if !storySnap.isSeen{
                    
                    snapIndex = snapIndexCount
                   // self.initTimerProgress()
                    print("current snap index in timer for set View will appear for \(story.user.userName): ", self.snapIndex)
                    let singleStoryImage = storySnap.storySnapUrl
                    self.storyImageView.kf.indicatorType = .activity
                    self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil, completionHandler:  {  (_) in
                        self.initeProgressViewAnimation()
                        self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)

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

                    self.initeProgressViewAnimation()
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
            self.initeProgressViewAnimation()
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
    
    
    
    func initeProgressViewAnimation () {
        UIView.animate(withDuration: 0.0, animations: {
            self.topProgressViews[self.snapIndex].layoutIfNeeded()
         }, completion: { finished in
            self.topProgressViews[self.snapIndex].progress = 1.0

            UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveLinear], animations: {
                self.topProgressViews[self.snapIndex].layoutIfNeeded()
             }, completion: { finished in
                 print("animation completed")
                self.snapIndex = self.snapIndex + 1
                self.nextAction()
             })
         })
    }
    
    
    
    @objc func closeButtonAction() {
        fullScreenStoryDelegateForCell?.snapClosed(isClosed:true, goToNextStory: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: story.snapsInSingleStory![self.currentSnapIndex])
        
    }
    
    @objc func nextAction() {
        
        let snapsInCurrentStory = story.snapsInSingleStory
        print("current snap for next Acction: ", self.snapIndex)
            if self.snapIndex < snapsInCurrentStory!.count {
                
                print("current snap Index: ", self.snapIndex)

                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
 }
            else {
               
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, goToNextStory: true, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snapsInSingleStory?.last)!)
                print("going to next story")
          }
            
        }

    
    
    @objc func prevAction() {
        var previousSnapCount = currentSnapIndex
            if previousSnapCount > 0 {
                self.topProgressViews[previousSnapCount].progress = 0.0
                previousSnapCount -= 1
                self.topProgressViews[previousSnapCount].progress = 0.0
                self.snapIndex = previousSnapCount
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                previousSnapCount -= 1
            }
            else {
                self.snapIndex = 0
                
                fullScreenStoryDelegateForCell?.snapClosed(isClosed:false, goToNextStory: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: story.snapsInSingleStory![self.currentSnapIndex])
              
            }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Finger touched!")
           // self.progressTimer.invalidate()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("finger is not touching.")
            //self.initTimerProgress()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            //print("Touch Move")
            //self.progressTimer.invalidate()
        }
    }
    
    
}
