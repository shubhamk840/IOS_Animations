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
        setupUI()
        cardView.layer.cornerRadius = 5
        view.addSubview(draggableCircleView)
        createAToastView()
        setUpArrow()
    }
    
    func setUpArrow() {
        let imageView = UIImageView(image: UIImage(named: "downArrow"))
        imageView.frame = CGRect(x: cardView.frame.origin.x + cardView.frame.size.width/2 - 17+0.5, y: cardView.frame.size.height+200, width: 35, height: 25)
        arrowView = imageView
        arrowView.layer.zPosition = 0
        addBlinkingEffect(On: arrowView)
        self.view.addSubview(arrowView)
    }
    
    func hideArrowView() {
        self.arrowView.isHidden = true
    }
    
    func addBlinkingEffect(On view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.repeat, .autoreverse] , animations: {
            view.alpha = 0
        })
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
    
    func setupUI() {
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
        
        
        //Setting view for the buttons.
        
        successButton.setImage(UIImage(named: "clickedButton"), for: .selected)
        successButton.setImage(UIImage(named: "unclickedButton"),for: .normal)
        failedButton.setImage(UIImage(named: "clickedButton"), for: .selected)
        failedButton.setImage(UIImage(named: "unclickedButton"),for: .normal)
        failedButton.isSelected = true
        
        // setting up selectorView
        
        selectorView.layer.borderWidth = 2
        selectorView.layer.cornerRadius = 5
    }
    
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
            if translation.y >= 0 {
                draggableCircleView.transform = CGAffineTransform(translationX: 0, y: translation.y)
                heightOfCard.constant = 288 - translation.y / 10
                widthOfTheCard.constant = 350 - translation.y / 10
                topSpaceForSelectorView.constant = 20 + translation.y / 15
            }
            print(translation.y)
        case .ended :
            print("stopped")
            if !Helper.checkIfViewLies(view: draggableCircleView, inside: containerCircleView) {
                returnToOlderPos()
                showTheToast(message: "Oops 😅 !! Pull harder", delay: 0)
            }
            else {
                self.heightOfCard.constant = 288
                self.widthOfTheCard.constant = 350
                topSpaceForSelectorView.constant = 20
                makeAnApiCall()
            }
        default :
            break
        }
    }
    
    
    func returnToOlderPos() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.heightOfCard.constant = 288
            self.widthOfTheCard.constant = 350
            self.draggableCircleView.transform = .identity
            self.topSpaceForSelectorView.constant = 20
        })
    }
    
    func hideContainerViewWhileLoading() {
        self.containerCircleView.layer.borderWidth = 0
    }
    
    func showContainerViewAfterLoading() {
        self.containerCircleView.layer.borderWidth = 5

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
        self.hideContainerViewWhileLoading()
        self.draggableCircleView.isHidden = true
        networkManager.fetchDataFromServer(endPoint: url, onSuccess: {
            response in
            Loaders.hideLoader(On: self.containerCircleView)
            if(response.success == true) {
                // This is the success
                self.hideArrowView()
                self.hideContainerView()
                self.showTheToast(message: "Woohoo 🥳 !!! Its a success", delay: 1)
            }
            else {
                self.draggableCircleView.isHidden = false
                self.showContainerViewAfterLoading()
                self.showTheToast(message: "Success false ☹️",delay: 0)
                self.returnToOlderPos()
            }
        }, onFailure: { error in
            self.draggableCircleView.isHidden = false
            self.showContainerViewAfterLoading()
            self.showTheToast(message: "Server Error ☹️ , Try again !!!",delay: 0)
            self.returnToOlderPos()
        })
    }
    
    
    func hideContainerView() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
            self.containerCircleView.center = CGPoint(x: self.containerCircleView.center.x, y: self.containerCircleView.center.y + 150)
            self.containerCircleView.alpha = 0

        })
    }
    
    func showTheToast(message:String, delay: Double) {
        self.label.alpha = 0
        self.label.text = message
        self.label.center = CGPoint(x: labelPosX ?? 0.0, y: labelPosY ?? 0.0)
        UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: {
            self.label.center = CGPoint(x: self.label.center.x, y: self.label.center.y - 80)
            self.label.alpha = 1
        
        })
    }
    
}

