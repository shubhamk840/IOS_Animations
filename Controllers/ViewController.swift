//
//  ViewController.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 06/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var topSpaceForSelectorView: NSLayoutConstraint!
    @IBOutlet weak var failedButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var containerCircleView: UIView!
    @IBOutlet weak var widthOfTheCard: NSLayoutConstraint!
    @IBOutlet weak var heightOfCard: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    
    
    var arrowView = UIView()
    var draggableCircleView = UIView()
    var label = UILabel()
    var labelPosX:CGFloat?
    var labelPosY:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUISetup()
        
    }
    
    func makeUISetup() {
        createAToastView()
        setUpArrow()
        setupDraggableCircle()
        view.addSubview(draggableCircleView)

    }
    
    func setUpArrow() {
        let imageView = UIImageView(image: UIImage(named: "downArrow"))
        imageView.frame = CGRect(x: cardView.frame.origin.x + cardView.frame.size.width/2 - 17+0.5, y: cardView.frame.size.height+200, width: 35, height: 25)
        arrowView = imageView
        arrowView.layer.zPosition = 0
        AnimationManager.addBlinkingEffect(On: arrowView)
        self.view.addSubview(arrowView)
    }
    
    func hideArrowView() {
        self.arrowView.isHidden = true
    }
    
    
    func createAToastView() {
        label = UILabel(frame: CGRect(x: cardView.frame.origin.x + cardView.frame.size.width/2 - 150+0.5, y: cardView.frame.size.height+20, width: 300, height: 20))
        labelPosX = label.center.x
        labelPosY = label.center.y
        label.textAlignment = .center
        label.text = "Success"
        label.textColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.alpha = 0
        label.layoutSubviews()
        self.view.addSubview(label)

    }
    
    func setupDraggableCircle() {
        
        cardView.layer.cornerRadius = 5
        containerCircleView.layer.cornerRadius = 55
        let diameterOfCircle:CGFloat = 100
        let view = UIView(frame: CGRect(x: cardView.frame.origin.x + cardView.frame.size.width/2 - 50+0.5, y: cardView.frame.size.height+20, width: diameterOfCircle, height: diameterOfCircle))
        
        //Adding cred's logo on the draggableCiricleView
        
        draggableCircleView = view
        draggableCircleView.layer.cornerRadius = 50
        draggableCircleView.backgroundColor = UIColor.black
        draggableCircleView.layer.zPosition = 1
        draggableCircleView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleDragOverCircle)))
        let credLogo = UIImageView(image: UIImage(named: "credsLogo"))
        credLogo.frame = CGRect(x: draggableCircleView.frame.size.width/2 - 30, y: draggableCircleView.frame.size.height/2 - 35, width: 60, height: 70)
        draggableCircleView.addSubview(credLogo)
        
        
        
        //Adding Border to the container Circle
        containerCircleView.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        containerCircleView.layer.borderWidth = 5
        
        
        //Setting image for the buttons.
        
        successButton.setImage(UIImage(named: "clickedButton"), for: .selected)
        successButton.setImage(UIImage(named: "unclickedButton"),for: .normal)
        failedButton.setImage(UIImage(named: "clickedButton"), for: .selected)
        failedButton.setImage(UIImage(named: "unclickedButton"),for: .normal)
        failedButton.isSelected = true
        
        // setting up selectorView
        
        selectorView.layer.borderWidth = 2
        selectorView.layer.cornerRadius = 5
    }
    
    func resetCardView() {
        self.heightOfCard.constant = 288
        self.widthOfTheCard.constant = 350
        topSpaceForSelectorView.constant = 20
    }
    
    
    // Events listener and handlers
    
    
    
    @IBAction func successButtonTapped(_ sender: Any) {
        successButton.isSelected = true
        failedButton.isSelected = false
    }
    
    @IBAction func failedButtonTapped(_ sender: Any) {
        failedButton.isSelected = true
        successButton.isSelected = false
    }
    
    
    @objc func handleDragOverCircle(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began :
            print("began")
            self.label.alpha = 0
        case .changed :
            print("dragging")
            let translation = gesture.translation(in: view)
            // This condition is to avoid, the user, dragging ball in upward direction
            if translation.y >= 0 {
                draggableCircleView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                heightOfCard.constant = 288 - translation.y / 10
                widthOfTheCard.constant = 350 - translation.y / 10
                topSpaceForSelectorView.constant = 20 + translation.y / 15
            }
        case .ended :
            print("stopped")
            // This function checks, if the draggableCircle lies inside the cointainer cirle.
            if !Helper.checkIfViewLies(view: draggableCircleView, inside: containerCircleView) {
                returnToOlderPos()
                AnimationManager.showTheToast(message: GenericMessages.unreached.rawValue , delay: 0, label: self.label, labelPosX: self.labelPosX , labelPosY: self.labelPosY)
            }
            else {
                resetCardView()
                makeAnApiCall()
            }
        default :
            break
        }
    }
    
    
    func returnToOlderPos() {
        AnimationManager.animateToOldPositions(view: self.draggableCircleView, completion: {
            self.resetCardView()
        })
    }
    
    
    func makeAnApiCall() {
        let networkManager = Services()
        let successUrl = "https://api.mocklets.com/p68348/success_case"
        let failedUrl = "https://api.mocklets.com/p68348/failure_case"
        
        var url:String = successUrl
        if failedButton.state == .selected {
            url = failedUrl
        }
        Loaders.showLoader(On: containerCircleView)
        AnimationManager.hideViewByReducingBorder(view: containerCircleView)
        self.draggableCircleView.isHidden = true
        networkManager.fetchDataFromServer(endPoint: url, onSuccess: {
            response in
            Loaders.hideLoader(On: self.containerCircleView)
            if(response.success == true) {
                // success == true case
                self.hideArrowView()
                AnimationManager.hideContainerView(containerCircleView: self.containerCircleView)
                AnimationManager.showTheToast(message: GenericMessages.success.rawValue, delay: 1, label: self.label, labelPosX: self.labelPosX, labelPosY:  self.labelPosY)
            }
            else {
                // success == false case
                self.draggableCircleView.isHidden = false
                AnimationManager.showViewByIncreasingBorder(view: self.containerCircleView)
                AnimationManager.showTheToast(message: GenericMessages.failure.rawValue ,delay: 0,label: self.label, labelPosX: self.labelPosX , labelPosY: self.labelPosY)
                self.returnToOlderPos()
            }
        }, onFailure: { error in
            // error case
            self.draggableCircleView.isHidden = false
            AnimationManager.showViewByIncreasingBorder(view: self.containerCircleView)
            AnimationManager.showTheToast(message: GenericMessages.error.rawValue ,delay: 0, label: self.label, labelPosX: self.labelPosX , labelPosY: self.labelPosY)
            self.returnToOlderPos()
        })
    }
    
    
    
    
}

