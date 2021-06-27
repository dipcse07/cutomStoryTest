//
//  StoryFullScreenViewer.swift
//  CustomStory
//
//  Created by Arif Amzad on 11/6/21.
//

import UIKit
import Kingfisher


class StoryFullScreenViewer: UIViewController {
    
    @IBOutlet var closeButton: UIButton! {
        didSet {
            self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        }
    }
    @IBOutlet var topTitleLabel: UILabel!
    @IBOutlet var storyImageView: UIImageView! 
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var leftIconImageView: UIImageView!
    @IBOutlet var rightIconImageView: UIImageView!
    @IBOutlet var progressViewHolder: UIView!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var visualEffectViewHolder: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    

    
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
    
    private var storyProperties = [StoryProperty]()
    public var currentViewingStoryIndex = 0
    private var storyImageIndex = 0
    public var stories: IGStories!
    var storyArray = [Story]()
    
//    var storyImageSrc = ""
//    var avatarImageSrc = ""
//    var topTitleText = ""
    private var progressTimer = Timer()
    private var automaticDissappearAfterSeconds = 5.0
    private var timerProgressStartAt = 0.0
    private var progressRate = 0.0
    private var topProgressViews = [UIProgressView]()
    public var showBlurEffectOnFullScreenView = true
    private let pangestureVelocity:CGFloat = 1000
    
    public func populateStoryProperties(stories: IGStories){
        let totalStories = stories.stories
        storyProperties.removeAll()
        for eachStory in totalStories {
            let avatar = eachStory.user.picture
        
          let userName = eachStory.user.name
            let lastUpdate = eachStory.lastUpdated
            
            if let snaps = eachStory.snaps {
                storyArray.removeAll()
                for eachSnap in snaps {
                    let imageUrl = eachSnap.url
                    let story = Story(image: imageUrl)
                    storyArray.append(story)
                }
               
                
               // print(storyProperty)
            }
            let storyProperty = StoryProperty(last_updated: lastUpdate, title: userName, avatar: avatar, story: storyArray)
            self.storyProperties.append(storyProperty)
            print("story properties from populates storyFunction: \n", storyProperties.debugDescription)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupViewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.progressTimer.invalidate()
        self.currentViewingStoryIndex = 0
        self.storyImageIndex = 0
        self.visualEffectViewHolder.alpha = 1.0
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeRight.direction = .right
           self.view.addGestureRecognizer(swipeRight)

           let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
           self.view.addGestureRecognizer(swipeLeft)
    }
    
    @IBAction func respondToSwipeGesture(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            // Perform action.
            switch gestureRecognizer.direction {
            case .left:
            print("swiped left")
                if currentViewingStoryIndex < storyProperties.count {
                    self.storyImageIndex = 0
                    self.timerProgressStartAt = 0.0
                    currentViewingStoryIndex += 1
                    
                    UIView.animate(withDuration: 0.2) {
                        self.setupViewWillAppear()
                    }
                }
                
            case .right:
            print("swiped right")
                if currentViewingStoryIndex > 0 {
                    self.storyImageIndex = 0
                    self.timerProgressStartAt = 0.0
                    currentViewingStoryIndex -= 1
                    
                    UIView.animate(withDuration: 0.2) {
                        self.setupViewWillAppear()
                    }
                }
            default:
                break
            }
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    private func setupViewDidLoad() {
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.15
        self.storyImageView.layer.cornerRadius = 20.0
        self.storyImageView.backgroundColor = .black
        self.progressRate = automaticDissappearAfterSeconds/1000
       
        
    }

    
    private func setupViewWillAppear() {
        
        if showBlurEffectOnFullScreenView {
            self.initBlurEffect()
        }
        else {
            self.visualEffectViewHolder.alpha = 0.0
        }
        
        self.avatarImageView.transform = .init(scaleX: 0.50, y: 0.50)
        self.topTitleLabel.transform = .init(scaleX: 1, y: 0.85)
        

        self.topTitleLabel.text = self.storyProperties[currentViewingStoryIndex].title
        
        let storyImages = self.storyProperties[currentViewingStoryIndex].story
        let singleStoryImage = storyImages[0].image
        self.storyImageView.kf.indicatorType = .activity
        self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil) { (_) in
            
        }
        let avatarImageLink = self.storyProperties[currentViewingStoryIndex].avatar
        self.avatarImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: URL(string: avatarImageLink), placeholder:  nil , options: nil) { (_) in
            
        }
        self.timeLabel.text = self.storyProperties[currentViewingStoryIndex].last_updated
        
        
        
        if currentViewingStoryIndex == 0 {
            self.leftIconImageView.isHidden = true
            self.rightIconImageView.isHidden = false
        }
        else if currentViewingStoryIndex == storyProperties.count - 1 {
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
    
        
    
    private func initBlurEffect() {
        //self.visualEffectViewHolder.alpha = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            UIView.animate(withDuration: 0.4) {
                self.visualEffectViewHolder.alpha = 0.0
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
        let storiyImages = self.storyProperties[currentViewingStoryIndex].story
        
        for _ in 0..<storiyImages.count {
            let progressView = UIProgressView()
            progressView.tintColor = .white
            progressView.progress = 0.0
            progressView.contentMode = .scaleAspectFill

            stackView.addArrangedSubview(progressView)
            self.topProgressViews.append(progressView)
        }
        self.progressViewHolder.addSubview(stackView)
    }
    
    
    
    private func updateStoryImages(index: Int) {
        let storiyImages = self.storyProperties[currentViewingStoryIndex].story
        let storyImageLink = storiyImages[index].image
        self.storyImageView.kf.setImage(with: URL(string: storyImageLink), placeholder:  nil , options: nil) { (_) in
            
        }
    }
    
    
    
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextAction() {
        
        let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
        
        if self.currentViewingStoryIndex < storyProperties.count-1 {

            
            if self.storyImageIndex < imagesInCurrentStory.count-1 {
                
                self.topProgressViews[storyImageIndex].progress = 1.0
                
                self.storyImageIndex += 1
                self.timerProgressStartAt = 0.0
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.storyImageIndex = 0
                self.timerProgressStartAt = 0.0
                currentViewingStoryIndex += 1
                UIView.animate(withDuration: 0.2) {
                    self.setupViewWillAppear()
                }
            }

        }
        else {
            if self.storyImageIndex < imagesInCurrentStory.count-1 {
                
            }
            else {
                self.closeButtonAction()
            }
            
        }
        
        

        
    }

    
    @objc func prevAction() {
        
        if self.currentViewingStoryIndex > 0 {
//            self.storyImageIndex = 0
//            currentViewingStoryIndex -= 1
//            UIView.animate(withDuration: 0.2) {
//                self.setupViewWillAppear()
//            }
            
            
//            let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
            if self.storyImageIndex > 0 {
                
                
                self.topProgressViews[storyImageIndex].progress = 0.0
                self.storyImageIndex -= 1
                self.topProgressViews[storyImageIndex].progress = 0.0
                self.timerProgressStartAt = 0.0
                
                
                
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
                }
                
                self.timerProgressStartAt += self.progressRate
            }
            else {
                self.storyImageIndex = 0
                self.timerProgressStartAt = 0.0
                currentViewingStoryIndex -= 1
                UIView.animate(withDuration: 0.2) {
                    self.setupViewWillAppear()
                }
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
            let imagesInCurrentStory = storyProperties[currentViewingStoryIndex].story
            
            if self.storyImageIndex < imagesInCurrentStory.count-1 {

                self.storyImageIndex += 1
                self.timerProgressStartAt = 0.0
                UIView.animate(withDuration: 0.2) {
                    self.updateStoryImages(index: self.storyImageIndex)
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
            if storyImageIndex < topProgressViews.count {
                self.topProgressViews[storyImageIndex].progress = Float(timerProgressStartAt)
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
