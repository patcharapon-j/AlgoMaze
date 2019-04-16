import UIKit
import PlaygroundSupport

class IntroViewController: UIViewController {
    
    var imageView: UIImageView!
    var spinnerMainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        
        //change background color
        self.view.backgroundColor = Colors.darkGreyPrimary
        
        //add app logo
        let image = UIImage(named: "logo.png")
        imageView = UIImageView(image: image)
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        let aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal,toItem: imageView, attribute: .width,multiplier: (1.0 / 1.0), constant: 0)
        imageView.addConstraint(aspectRatioConstraint)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        //add how to play button
        let howToPlayButton = UIButton(type: .custom)
        howToPlayButton.setTitle("How To Play", for: .normal)
        self.view.addSubview(howToPlayButton)
        
        howToPlayButton.layer.borderWidth = 2
        howToPlayButton.layer.borderColor = UIColor.white.cgColor
        howToPlayButton.layer.cornerRadius = 10
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        howToPlayButton.titleLabel?.font = UIFont(name: "avenirnext-demibold", size: 20)
        
        NSLayoutConstraint.activate([
            howToPlayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            howToPlayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            howToPlayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            howToPlayButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        howToPlayButton.addTarget(self, action: #selector(didTapHowToPlay), for: .touchUpInside)
        
        //add start button
        let startButton = UIButton(type: .custom)
        startButton.setTitle("Start", for: .normal)
        self.view.addSubview(startButton)
        
        startButton.backgroundColor = UIColor.white
        startButton.setTitleColor(Colors.bluePrimary, for: .normal)
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 10
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.titleLabel?.font = UIFont(name: "avenirnext-demibold", size: 20)
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: howToPlayButton.topAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/16))
        
        UIView.animate(withDuration: 5.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/16))
            
        }, completion: nil)
        
    }
    
    @objc private func didTapAboutMe() {
        
    }
    
    @objc private func didTapHowToPlay() {
        let howToPlayViewController = HowToPlayViewController()
        self.present(howToPlayViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapStart() {
        
        self.showActivityIndicator()
        DispatchQueue.main.async {
            let nextViewController = GameViewController()
            self.present(nextViewController, animated: true) {
                self.hideActivityIndicator()
            }
        }

    }
    
    func showActivityIndicator() {
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        spinnerView.addSubview(activityIndicator)
        self.view.addSubview(spinnerView)
        
        self.spinnerMainView = spinnerView
    }
    
    func hideActivityIndicator() {
        self.spinnerMainView?.removeFromSuperview()
        self.spinnerMainView = nil
    }
    
}


class HowToPlayViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "how-to-play-1.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapNext))
        imageView.addGestureRecognizer(gesture)
        
    }
    
    @objc func didTapNext() {
        currentIndex += 1
        if currentIndex <= 3 {
            imageView.image = UIImage(named: "how-to-play-\(currentIndex).png")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class GameViewController: UIViewController, UICollectionViewDataSource {
    
    let gameManager = GameManager()
    
    var gridContainerView: UIView!
    var collectionView: UICollectionView!
    var playerImageView: UIImageView!
    var executeButton: UIButton!
    var turnNumberLabel: UILabel!
    
    var gridImageViewArray: [[UIImageView]] = []
    var commandSequenceImageView: [UIImageView] = []
    var commandListImageView: [UIImageView] = []
    
    var gridWidth: CGFloat = 0.0
    var didPlacePlayer = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameManager.generateMaze()
        self.setupUI()
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = UIColor.white
        
        //setup grid view container
        gridContainerView = UIView(frame: CGRect.zero)
        
        self.view.addSubview(gridContainerView)
        
        NSLayoutConstraint.activate([
            gridContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            gridContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            gridContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            ])
        let aspectRatioConstraint = NSLayoutConstraint(item: gridContainerView, attribute: .height, relatedBy: .equal,toItem: gridContainerView, attribute: .width,multiplier: (1.0 / 1.0), constant: 0)
        gridContainerView.addConstraint(aspectRatioConstraint)
        gridContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        gridWidth = (view.bounds.width - 100) / 16
        
        //setup ImageView Grid
        for row in 0...7 {
            
            var imageViewList: [UIImageView] = []
            
            
            for col in 0...7 {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: gridWidth, height: gridWidth))
                
                let grid = gameManager.playGrid[row][col]
                switch grid {
                case .coin:
                    imageView.image = UIImage(named: "coin-tile.png")
                case .empty:
                    imageView.image = UIImage(named: "grass-tile.png")
                case .end:
                    imageView.image = UIImage(named: "flag-down-tile.png")
                case .key:
                    imageView.image = UIImage(named: "key-tile.png")
                case .start:
                    imageView.image = UIImage(named: "grass-tile.png")
                case .trapUp:
                    imageView.image = UIImage(named: "trap-up-tile")
                case .trapDown:
                    imageView.image = UIImage(named: "trap-down-tile")
                case .wall:
                    imageView.image = UIImage(named: "wall-tile.png")
                }
                
                
//                imageView.layer.borderWidth = 1
//                imageView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageViewList.append(imageView)
                self.gridContainerView.addSubview(imageView)
                
                switch row {
                case 0:
                    switch col {
                    case 0:
                        NSLayoutConstraint.activate([
                            imageView.topAnchor.constraint(equalTo: gridContainerView.topAnchor, constant: 0),
                            imageView.leadingAnchor.constraint(equalTo: gridContainerView.leadingAnchor, constant: 0),
                            imageView.widthAnchor.constraint(equalToConstant: gridWidth),
                            imageView.heightAnchor.constraint(equalToConstant: gridWidth)
                            ])
                    default:
                        NSLayoutConstraint.activate([
                            imageView.topAnchor.constraint(equalTo: gridContainerView.topAnchor, constant: 0),
                            imageView.leadingAnchor.constraint(equalTo: imageViewList[col-1].trailingAnchor, constant: 0),
                            imageView.widthAnchor.constraint(equalToConstant: gridWidth),
                            imageView.heightAnchor.constraint(equalToConstant: gridWidth)
                            ])
                    }
                default:
                    switch col {
                    case 0:
                        NSLayoutConstraint.activate([
                            imageView.topAnchor.constraint(equalTo: gridImageViewArray[row-1][col].bottomAnchor, constant: 0),
                            imageView.leadingAnchor.constraint(equalTo: gridContainerView.leadingAnchor, constant: 0),
                            imageView.widthAnchor.constraint(equalToConstant: gridWidth),
                            imageView.heightAnchor.constraint(equalToConstant: gridWidth)
                            ])
                    default:
                        NSLayoutConstraint.activate([
                            imageView.topAnchor.constraint(equalTo: gridImageViewArray[row-1][col].bottomAnchor, constant: 0),
                            imageView.leadingAnchor.constraint(equalTo: imageViewList[col-1].trailingAnchor, constant: 0),
                            imageView.widthAnchor.constraint(equalToConstant: gridWidth),
                            imageView.heightAnchor.constraint(equalToConstant: gridWidth)
                            ])
                    }
                }
                
            }
            
            gridImageViewArray.append(imageViewList)
        }
        
        //setup execxute button
        
        executeButton = UIButton(frame: CGRect.zero)
        executeButton.setTitle("Execute", for: .normal)
        executeButton.titleLabel?.font = UIFont(name: "avenirnext-demibold", size: 20)
        executeButton.backgroundColor = Colors.darkGreyExtraLight
        executeButton.translatesAutoresizingMaskIntoConstraints = false
        executeButton.layer.cornerRadius = 10
        executeButton.isEnabled = false
        self.view.addSubview(executeButton)
        
        NSLayoutConstraint.activate([
            executeButton.topAnchor.constraint(equalTo: gridImageViewArray[7][0].bottomAnchor, constant: 5),
            executeButton.leadingAnchor.constraint(equalTo: gridImageViewArray[7][0].leadingAnchor, constant: 20),
            executeButton.trailingAnchor.constraint(equalTo: gridImageViewArray[7][7].trailingAnchor, constant: -20),
            executeButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        executeButton.addTarget(self, action: #selector(didTapExecute), for: .touchUpInside)
        
        //setup command sequence imageview
        for num in 0...7 {
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.backgroundColor = Colors.darkGreyExtraLight
            self.commandSequenceImageView.append(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(imageView)
            
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = 10
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            
            switch num {
            case 0:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand1))
                imageView.addGestureRecognizer(gesture)
            case 1:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand2))
                imageView.addGestureRecognizer(gesture)
            case 2:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand3))
                imageView.addGestureRecognizer(gesture)
            case 3:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand4))
                imageView.addGestureRecognizer(gesture)
            case 4:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand5))
                imageView.addGestureRecognizer(gesture)
            case 5:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand6))
                imageView.addGestureRecognizer(gesture)
            case 6:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand7))
                imageView.addGestureRecognizer(gesture)
            case 7:
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCommand8))
                imageView.addGestureRecognizer(gesture)
            default:
                break
            }
            
            if num <= 3 {
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: executeButton.bottomAnchor, constant: 5),
                    imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0 + gridWidth + gridWidth * 1.5 * CGFloat(num)),
                    imageView.widthAnchor.constraint(equalToConstant: gridWidth * 1.5),
                    imageView.heightAnchor.constraint(equalToConstant: gridWidth * 1.5)
                    ])
            } else {
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: executeButton.bottomAnchor, constant: 5 + gridWidth*1.5),
                    imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0 + gridWidth + gridWidth * 1.5 * CGFloat(num-4)),
                    imageView.widthAnchor.constraint(equalToConstant: gridWidth * 1.5),
                    imageView.heightAnchor.constraint(equalToConstant: gridWidth * 1.5)
                    ])
            }
        }
        
        //setup command list
        
        let listWidth = gridWidth * 4 / 5
        
        for num in 0...4 {
            let imageView = UIImageView(frame: CGRect.zero)
            imageView.backgroundColor = Colors.darkGreyPrimary
            self.commandListImageView.append(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(imageView)
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = 10
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            
            switch num {
            case 0:
                imageView.image = UIImage(named: "walk.png")
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMove))
                imageView.addGestureRecognizer(gesture)
            case 1:
                imageView.image = UIImage(named: "anticlockwise-rotation.png")
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTurnLeft))
                imageView.addGestureRecognizer(gesture)
            case 2:
                imageView.image = UIImage(named: "clockwise-rotation.png")
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTurnRight))
                imageView.addGestureRecognizer(gesture)
            case 3:
                imageView.image = UIImage(named: "hand.png")
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapInteract))
                imageView.addGestureRecognizer(gesture)
            case 4:
                imageView.image = UIImage(named: "broad-dagger.png")
                let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAttack))
                imageView.addGestureRecognizer(gesture)
            default:
                break
            }
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: commandSequenceImageView[4].bottomAnchor, constant: 10),
                imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0 + listWidth * 2.0 * CGFloat(num)),
                imageView.widthAnchor.constraint(equalToConstant: listWidth * 2),
                imageView.heightAnchor.constraint(equalToConstant: listWidth * 2)
                ])
            
        }
        
        
        //setup back button
        
        let button = UIButton(frame: CGRect.zero)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont(name: "avenirnext-demibold", size: 18)
        button.backgroundColor = UIColor.red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        //setup turn remaining label
        let turnLabel = UILabel(frame: CGRect.zero)
        turnLabel.text = "Turns Left"
        turnLabel.font = UIFont(name: "avenirnext-medium", size: 20)
        turnLabel.translatesAutoresizingMaskIntoConstraints = false
        turnLabel.textColor = Colors.darkGreyLight
        
        turnNumberLabel = UILabel(frame: CGRect.zero)
        turnNumberLabel.text = "\(self.gameManager.turnsRemaining)"
        turnNumberLabel.font = UIFont(name: "avenirnext-bold", size: 40)
        turnNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        turnNumberLabel.textColor = Colors.darkGreyPrimary
        
        self.view.addSubview(turnNumberLabel)
        self.view.addSubview(turnLabel)
        
        NSLayoutConstraint.activate([
            turnNumberLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            turnNumberLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
            turnLabel.trailingAnchor.constraint(equalTo: turnNumberLabel.leadingAnchor, constant: -5),
            turnLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15)
            ])
        
        
        //setup player
        
    }
    
    override func viewDidLayoutSubviews() {

        if self.gridImageViewArray.count == 8 && !self.didPlacePlayer {
            let frame = gridImageViewArray[self.gameManager.playerPositionRow][self.gameManager.playerPositionCol].frame
            
            if frame.minX > 0 && frame.minY > 0 {
                playerImageView = UIImageView(frame: frame)
                playerImageView.contentMode = .scaleAspectFit
                playerImageView.image = UIImage(named: "narwhal.png")
                self.gridContainerView.addSubview(playerImageView)
                self.didPlacePlayer = true
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    @objc func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapExecute() {
        
        executeButton.isEnabled = false
        
        runCommand(at: 0)
        
    }
    
    private func runCommand(at index: Int) {
        
        self.executeButton.backgroundColor = UIColor.purple
        
        if index == 8 {
            gameManager.command = [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty]
            updateSelectedCommand()
            
            self.gameManager.turnsRemaining -= 1
            if self.gameManager.turnsRemaining == 0 {
                
                self.showGameOverAlert(message: "You ran out of turns. Try this maze again?")
                
            } else {
                self.turnNumberLabel.text = "\(self.gameManager.turnsRemaining)"
                self.gameManager.switchTraps()
                
                if gameManager.turnsRemaining <= 3 {
                    self.turnNumberLabel.textColor = UIColor.red
                } else {
                    self.turnNumberLabel.textColor = Colors.darkGreyPrimary
                }
                UIView.animate(withDuration: 0.5) {
                    self.updateGrid()
                }
                
                if gameManager.currentGrid == .trapUp {
                    self.showGameOverAlert(message: "Ouch! You are standing on upcoming saw. Try this maze again?")
                }
                
            }
            
        } else {
            let command = gameManager.command[index]
            
            for innerIndex in 0...7 {
                let imageView = self.commandSequenceImageView[innerIndex]
                if innerIndex == index {
                    imageView.backgroundColor = UIColor.purple
                } else {
                    imageView.backgroundColor = Colors.bluePrimary
                }
            }
            
            switch command {
            case .attack:
                switch gameManager.currentFacing {
                case .north:
                    let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow - 1][gameManager.playerPositionCol]
                    
                    let dFrame = destinationImageView.frame
                    let destinationFrame = CGRect(x: dFrame.minX, y: dFrame.minY + self.gridWidth/2, width: dFrame.width, height: dFrame.height)
                    
                    let originalFrame = self.playerImageView.frame
                    
                    
                    UIView.setAnimationCurve(.linear)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.playerImageView.frame = destinationFrame
                    }) { (_) in
                        
                        let destinationGrid = self.gameManager.playGrid[self.gameManager.playerPositionRow - 1][self.gameManager.playerPositionCol]
                        if destinationGrid == .wall {
                            self.gameManager.playGrid[self.gameManager.playerPositionRow - 1][self.gameManager.playerPositionCol] = .empty
                            UIView.animate(withDuration: 0.5) {
                                self.updateGrid()
                            }
                        }
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            self.playerImageView.frame = originalFrame
                        }) { (_) in
                            UIView.setAnimationCurve(.easeInOut)
                            self.runCommand(at: index + 1)
                        }
                    }
                case .east:
                    let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol + 1]
                    
                    let dFrame = destinationImageView.frame
                    let destinationFrame = CGRect(x: dFrame.minX - self.gridWidth/2, y: dFrame.minY, width: dFrame.width, height: dFrame.height)
                    
                    let originalFrame = self.playerImageView.frame
                    
                    UIView.setAnimationCurve(.linear)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.playerImageView.frame = destinationFrame
                    }) { (_) in
                        
                        let destinationGrid = self.gameManager.playGrid[self.gameManager.playerPositionRow][self.gameManager.playerPositionCol + 1]
                        if destinationGrid == .wall {
                            self.gameManager.playGrid[self.gameManager.playerPositionRow][self.gameManager.playerPositionCol + 1] = .empty
                            UIView.animate(withDuration: 0.5) {
                                self.updateGrid()
                            }
                        }
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            self.playerImageView.frame = originalFrame
                        }) { (_) in
                            UIView.setAnimationCurve(.easeInOut)
                            self.runCommand(at: index + 1)
                        }
                    }
                case .west:
                    let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol - 1]
                    
                    let dFrame = destinationImageView.frame
                    let destinationFrame = CGRect(x: dFrame.minX + self.gridWidth/2, y: dFrame.minY, width: dFrame.width, height: dFrame.height)
                    
                    let originalFrame = self.playerImageView.frame
                    
                    UIView.setAnimationCurve(.linear)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.playerImageView.frame = destinationFrame
                    }) { (_) in
                        
                        let destinationGrid = self.gameManager.playGrid[self.gameManager.playerPositionRow][self.gameManager.playerPositionCol - 1]
                        if destinationGrid == .wall {
                            self.gameManager.playGrid[self.gameManager.playerPositionRow][self.gameManager.playerPositionCol - 1] = .empty
                            UIView.animate(withDuration: 0.5) {
                                self.updateGrid()
                            }
                        }
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            self.playerImageView.frame = originalFrame
                        }) { (_) in
                            UIView.setAnimationCurve(.easeInOut)
                            self.runCommand(at: index + 1)
                        }
                    }
                case .south:
                    let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow + 1][gameManager.playerPositionCol]
                    
                    let dFrame = destinationImageView.frame
                    let destinationFrame = CGRect(x: dFrame.minX, y: dFrame.minY - self.gridWidth/2, width: dFrame.width, height: dFrame.height)
                    
                    let originalFrame = self.playerImageView.frame
                    
                    UIView.setAnimationCurve(.linear)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.playerImageView.frame = destinationFrame
                    }) { (_) in
                        
                        let destinationGrid = self.gameManager.playGrid[self.gameManager.playerPositionRow + 1][self.gameManager.playerPositionCol]
                        if destinationGrid == .wall {
                            self.gameManager.playGrid[self.gameManager.playerPositionRow + 1][self.gameManager.playerPositionCol] = .empty
                            UIView.animate(withDuration: 0.5) {
                                self.updateGrid()
                            }
                        }
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            self.playerImageView.frame = originalFrame
                        }) { (_) in
                            UIView.setAnimationCurve(.easeInOut)
                            self.runCommand(at: index + 1)
                        }
                    }
                }
            case .empty:
                break
            case .move:
                switch gameManager.currentFacing {
                case .north:
                    if gameManager.playerPositionRow - 1 >= 0 {
                        
                        let destinationGrid =  gameManager.playGrid[gameManager.playerPositionRow - 1][gameManager.playerPositionCol]
                        
                        switch destinationGrid {
                        case .empty, .coin, .key, .start, .trapDown:
                            gameManager.playerPositionRow -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.runCommand(at: index + 1)
                            }
                        case .end:
                            gameManager.playerPositionRow -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                if self.gameManager.keysCollected == self.gameManager.keysNeeded {
                                    self.showYouWinAlert()
                                } else {
                                    self.runCommand(at: index + 1)
                                }
                            }
                            
                            
                            
                        case .trapUp:
                            gameManager.playerPositionRow -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.showGameOverAlert(message: "Ouch! You walk into a saw! Try this maze again?")
                            }
                            
                            
                        case .wall:
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow - 1][gameManager.playerPositionCol]
                            
                            let dFrame = destinationImageView.frame
                            let destinationFrame = CGRect(x: dFrame.minX, y: dFrame.minY + self.gridWidth/2, width: dFrame.width, height: dFrame.height)
                            
                            let originalFrame = self.playerImageView.frame
   
                            UIView.setAnimationCurve(.linear)
                            UIView.animate(withDuration: 0.25, animations: {
                                self.playerImageView.frame = destinationFrame
                            }) { (_) in
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.playerImageView.frame = originalFrame
                                }) { (_) in
                                    UIView.setAnimationCurve(.easeInOut)
                                    self.runCommand(at: index + 1)
                                }
                            }
                        }
                    
                        
                    } else {
                        self.runCommand(at: index + 1)
                    }
                case .east:
                    if gameManager.playerPositionCol + 1 <= 7 {
                        
                        let destinationGrid =  gameManager.playGrid[gameManager.playerPositionRow][gameManager.playerPositionCol + 1]
                        
                        switch destinationGrid {
                        case .empty, .coin, .key, .start, .trapDown:
                            gameManager.playerPositionCol += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.runCommand(at: index + 1)
                            }
                        case .end:
                            gameManager.playerPositionCol += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                if self.gameManager.keysCollected == self.gameManager.keysNeeded {
                                    self.showYouWinAlert()
                                } else {
                                    self.runCommand(at: index + 1)
                                }
                            }
                            
                        case .trapUp:
                            gameManager.playerPositionCol += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.showGameOverAlert(message: "Ouch! You walk into a saw! Try this maze again?")
                            }
                            
                        case .wall:
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol + 1]
                            
                            let dFrame = destinationImageView.frame
                            let destinationFrame = CGRect(x: dFrame.minX - self.gridWidth/2, y: dFrame.minY, width: dFrame.width, height: dFrame.height)
                            
                            let originalFrame = self.playerImageView.frame
                            
                            UIView.setAnimationCurve(.linear)
                            UIView.animate(withDuration: 0.25, animations: {
                                self.playerImageView.frame = destinationFrame
                            }) { (_) in
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.playerImageView.frame = originalFrame
                                }) { (_) in
                                    UIView.setAnimationCurve(.easeInOut)
                                    self.runCommand(at: index + 1)
                                }
                            }
                        }
                    } else {
                        self.runCommand(at: index + 1)
                    }
                case .west:
                    if gameManager.playerPositionCol - 1 >= 0 {
                        
                        let destinationGrid =  gameManager.playGrid[gameManager.playerPositionRow][gameManager.playerPositionCol - 1]
                        
                        switch destinationGrid {
                        case .empty, .coin, .key, .start, .trapDown:
                            gameManager.playerPositionCol -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.runCommand(at: index + 1)
                            }
                        case .end:
                            gameManager.playerPositionCol -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                if self.gameManager.keysCollected == self.gameManager.keysNeeded {
                                    self.showYouWinAlert()
                                } else {
                                    self.runCommand(at: index + 1)
                                }
                            }
                        case .trapUp:
                            gameManager.playerPositionCol -= 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.showGameOverAlert(message: "Ouch! You walk into a saw! Try this maze again?")
                            }
                            
                        case .wall:
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol - 1]
                            
                            let dFrame = destinationImageView.frame
                            let destinationFrame = CGRect(x: dFrame.minX + self.gridWidth/2, y: dFrame.minY, width: dFrame.width, height: dFrame.height)
                            
                            let originalFrame = self.playerImageView.frame
                            
                            UIView.setAnimationCurve(.linear)
                            UIView.animate(withDuration: 0.25, animations: {
                                self.playerImageView.frame = destinationFrame
                            }) { (_) in
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.playerImageView.frame = originalFrame
                                }) { (_) in
                                    UIView.setAnimationCurve(.easeInOut)
                                    self.runCommand(at: index + 1)
                                }
                            }
                        }
                    } else {
                        self.runCommand(at: index + 1)
                    }
                case .south:
                    if gameManager.playerPositionRow + 1 <= 7 {
                        
                        let destinationGrid =  gameManager.playGrid[gameManager.playerPositionRow + 1][gameManager.playerPositionCol]
                        
                        switch destinationGrid {
                        case .empty, .coin, .key, .start, .trapDown:
                            gameManager.playerPositionRow += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.runCommand(at: index + 1)
                            }
                        case .end:
                            gameManager.playerPositionRow += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                if self.gameManager.keysCollected == self.gameManager.keysNeeded {
                                    self.showYouWinAlert()
                                } else {
                                    self.runCommand(at: index + 1)
                                }
                            }
                            
                        case .trapUp:
                            gameManager.playerPositionRow += 1
                            
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow][gameManager.playerPositionCol]
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.playerImageView.frame = destinationImageView.frame
                            }) { (_) in
                                self.showGameOverAlert(message: "Ouch! You walk into a saw! Try this maze again?")
                            }
                            
                        case .wall:
                            let destinationImageView = self.gridImageViewArray[gameManager.playerPositionRow + 1][gameManager.playerPositionCol]
                            
                            let dFrame = destinationImageView.frame
                            let destinationFrame = CGRect(x: dFrame.minX, y: dFrame.minY - self.gridWidth/2, width: dFrame.width, height: dFrame.height)
                            
                            let originalFrame = self.playerImageView.frame
                            
                            UIView.setAnimationCurve(.linear)
                            UIView.animate(withDuration: 0.25, animations: {
                                self.playerImageView.frame = destinationFrame
                            }) { (_) in
                                UIView.animate(withDuration: 0.25, animations: {
                                    self.playerImageView.frame = originalFrame
                                }) { (_) in
                                    UIView.setAnimationCurve(.easeInOut)
                                    self.runCommand(at: index + 1)
                                }
                            }
                        }
                        
                        
                    } else {
                        self.runCommand(at: index + 1)
                    }
                }
            case .interact:
                let currentGrid = gameManager.currentGrid
                switch currentGrid{
                case .coin:
                    gameManager.playGrid[gameManager.playerPositionRow][gameManager.playerPositionCol] = .empty
                    gameManager.turnsRemaining += 1
                    self.turnNumberLabel.text = "\(self.gameManager.turnsRemaining)"
                    
                    if gameManager.turnsRemaining <= 3 {
                        self.turnNumberLabel.textColor = UIColor.red
                    } else {
                        self.turnNumberLabel.textColor = Colors.darkGreyPrimary
                    }
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.updateGrid()
                    }) { (_) in
                        self.runCommand(at: index+1)
                    }
                    
                    
                    
                case .key:

                    gameManager.playGrid[gameManager.playerPositionRow][gameManager.playerPositionCol] = .empty
                    gameManager.keysCollected += 1
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.updateGrid()
                    }) { (_) in
                        self.runCommand(at: index+1)
                    }
                    
                default:
                    self.runCommand(at: index+1)
                }
            case .turnLeft:
                self.gameManager.turnLeft()
                UIView.animate(withDuration: 0.5, animations: {
                    switch self.gameManager.currentFacing {
                    case .north:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                    case .east:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    case .west:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
                    case .south:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }
                }) { (_) in
                    self.runCommand(at: index+1)
                }
                
                
            case .turnRight:
                self.gameManager.turnRight()
                UIView.animate(withDuration: 0.5, animations: {
                    switch self.gameManager.currentFacing {
                    case .north:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                    case .east:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                    case .west:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
                    case .south:
                        self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }
                }) { (_) in
                    self.runCommand(at: index+1)
                }
            }
        }
    }
    
    @objc func didTapMove() {
        for index in 0...7 {
            if gameManager.command[index] == .empty {
                gameManager.command[index] = .move
                updateSelectedCommand()
                break
            }
        }
    }
    
    @objc func didTapTurnLeft() {
        for index in 0...7 {
            if gameManager.command[index] == .empty {
                gameManager.command[index] = .turnLeft
                updateSelectedCommand()
                break
            }
        }
    }
    
    @objc func didTapTurnRight() {
        for index in 0...7 {
            if gameManager.command[index] == .empty {
                gameManager.command[index] = .turnRight
                updateSelectedCommand()
                break
            }
        }
    }
    
    @objc func didTapInteract() {
        for index in 0...7 {
            if gameManager.command[index] == .empty {
                gameManager.command[index] = .interact
                updateSelectedCommand()
                break
            }
        }
    }
    
    @objc func didTapAttack() {
        for index in 0...7 {
            if gameManager.command[index] == .empty {
                gameManager.command[index] = .attack
                updateSelectedCommand()
                break
            }
        }
    }
    
    @objc func didTapCommand1() {
        gameManager.command[0] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand2() {
        gameManager.command[1] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand3() {
        gameManager.command[2] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand4() {
        gameManager.command[3] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand5() {
        gameManager.command[4] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand6() {
        gameManager.command[5] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand7() {
        gameManager.command[6] = .empty
        self.updateSelectedCommand()
    }
    
    @objc func didTapCommand8() {
        gameManager.command[7] = .empty
        self.updateSelectedCommand()
    }
    
    private func updateGrid() {
        
        for row in 0...7 {
            for col in 0...7 {
                let imageView = gridImageViewArray[row][col]
                
                let grid = gameManager.playGrid[row][col]
                switch grid {
                case .coin:
                    imageView.image = UIImage(named: "coin-tile.png")
                case .empty:
                    imageView.image = UIImage(named: "grass-tile.png")
                case .end:
                    if gameManager.keysCollected == gameManager.keysNeeded {
                        imageView.image = UIImage(named: "flag-up-tile.png")
                    } else {
                        imageView.image = UIImage(named: "flag-down-tile.png")
                    }
                case .key:
                    imageView.image = UIImage(named: "key-tile.png")
                case .start:
                    imageView.image = UIImage(named: "grass-tile.png")
                case .trapUp:
                    imageView.image = UIImage(named: "trap-up-tile")
                case .trapDown:
                    imageView.image = UIImage(named: "trap-down-tile")
                case .wall:
                    imageView.image = UIImage(named: "wall-tile.png")
                }
            }
        }
    }
    
    private func updateSelectedCommand() {
        
        var readyToExecute = true
        
        for index in 0...7 {
            let imageView = commandSequenceImageView[index]
            switch gameManager.command[index] {
            case .empty:
                imageView.backgroundColor = Colors.darkGreyExtraLight
                imageView.image = nil
                readyToExecute = false
            case .interact:
                imageView.backgroundColor = Colors.bluePrimary
                imageView.image = UIImage(named: "hand.png")
            case .move:
                imageView.backgroundColor = Colors.bluePrimary
                imageView.image = UIImage(named: "walk.png")
            case .turnLeft:
                imageView.backgroundColor = Colors.bluePrimary
                imageView.image = UIImage(named: "anticlockwise-rotation.png")
            case .turnRight:
                imageView.backgroundColor = Colors.bluePrimary
                imageView.image = UIImage(named: "clockwise-rotation.png")
            case .attack:
                imageView.backgroundColor = Colors.bluePrimary
                imageView.image = UIImage(named: "broad-dagger.png")
            }
        }
        
        if readyToExecute {
            executeButton.backgroundColor = Colors.blueGreyDark
            executeButton.isEnabled = true
            
            for imageView in self.commandListImageView {
                imageView.backgroundColor = Colors.darkGreyExtraLight
                imageView.isUserInteractionEnabled = false
            }
            
        } else {
            executeButton.backgroundColor = Colors.darkGreyExtraLight
            executeButton.isEnabled = false
            
            for imageView in self.commandListImageView {
                imageView.backgroundColor = Colors.darkGreyPrimary
                imageView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func showYouWinAlert() {
        let alert = UIAlertController(title: "You Win", message: "congratulations! You are amazing. Play this maze again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Again", style: .default, handler: { (_) in
            self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showGameOverAlert(message: String) {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (_) in
            self.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetGame() {
        gameManager.turnsRemaining = 5
        gameManager.currentFacing = .north
        gameManager.playerPositionCol = 1
        gameManager.playerPositionRow = 6
        gameManager.keysCollected = 0
        gameManager.playGrid = gameManager.originalPlayGrid
        turnNumberLabel.text = "\(self.gameManager.turnsRemaining)"
        turnNumberLabel.textColor = Colors.darkGreyPrimary
        gameManager.command = [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty]
        
        let destinationImageView = self.gridImageViewArray[6][1]
        
        UIView.animate(withDuration: 0.5) {
            self.playerImageView.frame = destinationImageView.frame
            self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        }
        
        UIView.animate(withDuration: 0.5) {
            self.updateGrid()
        }
        self.updateSelectedCommand()
    }
}

class GameManager {
    
    enum PlayGridMember {
        case empty
        case wall
        case trapUp
        case trapDown
        case coin
        case key
        case start
        case end
    }
    
    enum GameCommand {
        case move
        case turnLeft
        case turnRight
        case interact
        case attack
        case empty
    }
    
    enum PlayerFacing {
        case north
        case east
        case west
        case south
    }
    
    var playGrid: [[PlayGridMember]] = [
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .start, .empty, .empty, .empty, .empty, .empty, .empty],
    [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty]
    ]
    
    var originalPlayGrid: [[PlayGridMember]] = []
    
    let keysNeeded = 5
    
    var playerPositionRow = 6
    var playerPositionCol = 1
    var turnsRemaining = 5
    var keysCollected = 0
    var command: [GameCommand] = [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty]
    var currentFacing: PlayerFacing = .north
    
    var currentGrid: PlayGridMember {
        get {
            return self.playGrid[self.playerPositionRow][self.playerPositionCol]
        }
    }
    
    
    func generateMaze() {
        
        //place Key
        var createdkey = 0
        while createdkey < self.keysNeeded {
            let row = Int.random(in: 0...7)
            let col = Int.random(in: 0...7)
            
            if playGrid[row][col] == .empty {
                playGrid[row][col] = .key
                createdkey += 1
            }
        }
        
        while true {
            let row = Int.random(in: 0...7)
            let col = Int.random(in: 0...7)
            if playGrid[row][col] == .empty {
                playGrid[row][col] = .end
                break
            }
        }
        
        for rowIndex in 0...7 {
            for colIndex in 0...7 {
                let grid = playGrid[rowIndex][colIndex]
                if grid == .empty {
                    let random = Int.random(in: 1...20)
                    switch random {
                    case 14...19:
                        playGrid[rowIndex][colIndex] = .wall
                    case 1...2:
                        playGrid[rowIndex][colIndex] = .coin
                    case 3...7:
                        let trapRandom = Int.random(in: 0...1)
                        if trapRandom == 0 {
                            playGrid[rowIndex][colIndex] = .trapUp
                        } else {
                            playGrid[rowIndex][colIndex] = .trapDown
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        
        originalPlayGrid = playGrid
        
    }
    
    func switchTraps() {
        for rowIndex in 0...7 {
            for colIndex in 0...7 {
                let grid = playGrid[rowIndex][colIndex]
                if grid == .trapDown {
                    playGrid[rowIndex][colIndex] = .trapUp
                } else if grid == .trapUp {
                    playGrid[rowIndex][colIndex] = .trapDown
                }
            }
        }
    }
    
    func turnLeft() {
        switch self.currentFacing {
        case .north:
            self.currentFacing = .west
        case .east:
            self.currentFacing = .north
        case .west:
            self.currentFacing = .south
        case .south:
            self.currentFacing = .east
        }
    }
    
    func turnRight() {
        switch self.currentFacing {
        case .north:
            self.currentFacing = .east
        case .east:
            self.currentFacing = .south
        case .west:
            self.currentFacing = .north
        case .south:
            self.currentFacing = .west
        }
    }
    
}

class Colors {
    static let darkGreyPrimary = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
    static let darkGreyLight = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
    static let darkGreyDark = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
    static let darkGreyExtraLight = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    
    static let bluePrimary = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
    static let blueGreyLight = UIColor(red: 110/255, green: 198/255, blue: 255/255, alpha: 1)
    static let blueGreyDark = UIColor(red: 0/255, green: 105/255, blue: 192/255, alpha: 1)
}




//Initialize Playground
PlaygroundPage.current.liveView = IntroViewController()
PlaygroundPage.current.needsIndefiniteExecution = true

//Creator
//Patcharapon Joksamut
//p.joksamut@gmail.com

//credits
//Command Symbol Image from game-icons.net
//grid tile and character from kenney at opengameart
