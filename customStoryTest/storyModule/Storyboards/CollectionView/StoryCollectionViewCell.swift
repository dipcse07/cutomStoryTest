//
//  StoryCollectionViewCell.swift
//  customStoryTest
//
//  Created by MD SAZID HASAN DIP on 28/6/21.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // self.setupViewDidLoad()
        //self.setupViewWillAppear()
    }
    public var stories: IGStory! {
        didSet{
            print(stories.debugDescription)
            print(stories.snaps?.count)
            self.setupViewDidLoad()
             self.setupViewWillAppear()
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
    private var storyImageIndex = 0
    public var igStories: IGStories!
  //  private var stories = [IGStory]()
    
    

    private var progressTimer = Timer()
    private var automaticDissappearAfterSeconds = 5.0
    private var timerProgressStartAt = 0.0
    private var progressRate = 0.0
    private var topProgressViews = [UIProgressView]()
    public var showBlurEffectOnFullScreenView = true
    private let pangestureVelocity:CGFloat = 1000
    var fullScreenStoryDelegateForCell: FullScreenSotryDelegate!
    
    internal static func instantiate(with stories: IGStories, handPickedStoryIndex: Int, delegate:FullScreenSotryDelegate) -> StoryFullScreenViewer {

        let vc = UIStoryboard(name: "StoryView", bundle: nil).instantiateViewController(withIdentifier: "StoryFullScreenViewer") as! StoryFullScreenViewer
        vc.igStories = stories
        vc.fullScreenStoryDelegate = delegate
        
        return vc
    }


    @IBAction func respondToSwipeGesture(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            // Perform action.
            switch gestureRecognizer.direction {
            case .left:
            print("swiped left")
                if currentViewingStoryIndex < stories.snaps!.count - 1 {
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

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }


    private func setupViewDidLoad() {
        //self.stories = igStories.stories
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width * 0.50
        self.storyImageView.layer.cornerRadius = 20.0
        self.storyImageView.backgroundColor = .black
        self.progressRate = automaticDissappearAfterSeconds/1000

//       let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//           swipeRight.direction = .right
//           self.view.addGestureRecognizer(swipeRight)
//
//           let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeLeft.direction = .left
//           self.view.addGestureRecognizer(swipeLeft)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action

        fullScreenStoryDelegateForCell.profileImageTapped(userInfo: stories.user)


    }


    private func setupViewWillAppear() {

        self.avatarImageView.transform = .init(scaleX: 0.50, y: 0.50)
        self.topTitleLabel.transform = .init(scaleX: 1, y: 0.85)


        self.topTitleLabel.text = stories.user.name

        let storyImages = stories.snaps
        
        if let singleStoryImage = storyImages?.first?.url{
        self.storyImageView.kf.indicatorType = .activity
        self.storyImageView.kf.setImage(with: URL(string: singleStoryImage), placeholder: nil , options: nil) { (_) in

        }
        }
        let avatarImageLink = stories.user.picture
        //print("avatar image: ", avatarImageLink)
        self.storyImageView.kf.indicatorType = .activity
        self.avatarImageView.kf.setImage(with: URL(string: avatarImageLink), placeholder:  nil , options: nil) { (_) in

        }
        self.timeLabel.text = stories.lastUpdated



        if currentViewingStoryIndex == 0 {
            self.leftIconImageView.isHidden = true
            self.rightIconImageView.isHidden = false
        }
        else if currentViewingStoryIndex == stories.snaps!.count  - 1 {
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
        let storiyImages = stories.snaps

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



    private func updateStoryImages(index: Int) {
        let storiyImages = stories.snaps
        let storyImageLink = storiyImages![index].url
      
        fullScreenStoryDelegateForCell.currentStoryAndSnap(story: self.stories, snap: stories.snaps![index] )
        self.storyImageView.kf.setImage(with: URL(string: storyImageLink), placeholder:  nil , options: nil) { (_) in

        }
    }




    @objc func closeButtonAction() {
        self.progressTimer.invalidate()
        fullScreenStoryDelegateForCell.storiesClosed()
        
    }

    @objc func nextAction() {

        let imagesInCurrentStory = stories.snaps

        if self.currentViewingStoryIndex < imagesInCurrentStory!.count-1 {


            if self.storyImageIndex < imagesInCurrentStory!.count-1 {

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
                self.progressTimer.invalidate()
                currentViewingStoryIndex += 1
                fullScreenStoryDelegateForCell.nextStory()
                print("going to next story")
//                UIView.animate(withDuration: 0.2) {
//                    self.setupViewWillAppear()
//                }
              
                
                
            }

        }
        else {
            if self.storyImageIndex < imagesInCurrentStory!.count-1 {

            }
            else {
                currentViewingStoryIndex = 0
                self.progressTimer.invalidate()
                fullScreenStoryDelegateForCell.nextStory()
                print("going to next story")
            }

        }




    }


    @objc func prevAction() {

        if self.currentViewingStoryIndex > 0 {
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
            let imagesInCurrentStory = stories.snaps

            if self.storyImageIndex < imagesInCurrentStory!.count-1 {

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
