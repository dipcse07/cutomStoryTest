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
    public var story: IGStory! {
        didSet{
            self.setupViewWillAppear()
            print("story count after Passing story",story.snaps?.count)
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
    
    public var currentViewingStoryIndex = 0
    private var snapIndex = 0
    public var igStories: IGStories!
    private var snapCount = 0
    //  private var stories = [IGStory]()
    private var nextSnapIndex = 0
    public var storyIndexPath: IndexPath!
    
    
    
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
        
        self.topTitleLabel.text = story.user.name
        
        if let storySnaps = story.snaps, !story!.isSeen {
            for storySnap in storySnaps {
                print(storySnap)
                if !storySnap.isSeen{
                   
                    let singleStoryImage = storySnap.url
                    self.storyImageView.kf.indicatorType = .activity
                    self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil, completionHandler:  {  (_) in
                        self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                    })
                break
                    
                } else {
                    
                }
            }
        } else {
            if let storySnap = story.snaps?.first{
                let singleStoryImage  = storySnap.url
                self.storyImageView.kf.indicatorType = .activity
                self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil) { (_) in
                    self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: storySnap)
                }
            }
        }
        
        let avatarImageLink = story.user.picture
        //print("avatar image: ", avatarImageLink)
        self.storyImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: URL(string: avatarImageLink), placeholder:  nil , options: nil) { (_) in
            
        }
        self.timeLabel.text = story.lastUpdated
        
        
        
        if currentViewingStoryIndex == 0 {
            self.leftIconImageView.isHidden = true
            self.rightIconImageView.isHidden = false
        }
        else if currentViewingStoryIndex == story.snaps!.count  - 1 {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = true
        }
        else {
            self.leftIconImageView.isHidden = false
            self.rightIconImageView.isHidden = false
        }
        
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
        
        self.initProgressViews()
        self.initTimerProgress()
        
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
        let storiyImages = story.snaps
        
        for _ in 0..<storiyImages!.count {
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
        if let snaps = story.snaps {
            if index > 0 {
                self.fullScreenStoryDelegateForCell?.snapDidDisappear(previousSnap: snaps[index - 1])
            }
        let storyImageLink = snaps[index].url
        
        
        self.storyImageView.kf.setImage(with: URL(string: storyImageLink), placeholder:  nil , options: nil) { (_) in
            self.fullScreenStoryDelegateForCell?.snapDidAppear(currentSnapInProgress: snaps[index] )
        }
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
        fullScreenStoryDelegateForCell?.snapClosed(isClosed:true, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: story.snaps![snapIndex])
        
    }
    
    @objc func nextAction() {
        
        let imagesInCurrentStory = story.snaps
        
        if self.currentViewingStoryIndex < imagesInCurrentStory!.count-1 {
            
            
            if self.snapIndex < imagesInCurrentStory!.count-1 {
                
                self.topProgressViews[snapIndex].progress = 1.0
                
                self.snapIndex += 1
                self.timerProgressStartAt = 0.0
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.snapIndex = 0
                self.progressTimer.invalidate()
                currentViewingStoryIndex += 1
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snaps?.last)!)
                print("going to next story")
                //                UIView.animate(withDuration: 0.2) {
                //                    self.setupViewWillAppear()
                //                }
          }
            
        }
        else {
            if self.snapIndex < imagesInCurrentStory!.count-1 {
                
            }
            else {
                currentViewingStoryIndex = 0
                self.progressTimer.invalidate()
                fullScreenStoryDelegateForCell?.snapClosed(isClosed: false, atStroy: story, forStoryIndexPath: storyIndexPath, forSnap: (story.snaps?.last)!)
                print("going to next story")
            }
            
        }
    }
    
    
    @objc func prevAction() {
        
        if self.currentViewingStoryIndex > 0 {
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
                currentViewingStoryIndex -= 1
                //                UIView.animate(withDuration: 0.2) {
                //                    self.setupViewWillAppear()
                //                }
            }
            
            
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
            let imagesInCurrentStory = story.snaps
            
            if self.snapIndex < imagesInCurrentStory!.count-1 {
                
                self.snapIndex += 1
                self.timerProgressStartAt = 0.0
                UIView.animate(withDuration: 0.2) {
                    self.updateSnap(index: self.snapIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                //                self.timerProgressStartAt = 0.0
                //                self.storyImageIndex = 0
                //self.closeButtonAction()
                
                for progressView in topProgressViews {
                    progressView.progress = 0.0
                }
                
                self.initProgressViews()
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
