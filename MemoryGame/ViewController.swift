import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    //change to change possible time
    var milliseconds:Int = 60 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray =  model.getCards()
        
        //set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        // play shuffle sounds
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        // play shuffle sounds
        soundPlayer.playSound(effect: .shuffle)
    }
    //MARK: - Timer methods
    
    @objc func timerFired(){
        
        // Decrement the counter
        milliseconds -= 1
        
        //update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        //stop the timer if it reaches zero
        if milliseconds == 0{
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            //check if the user has cleared all the pairs
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection view delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cell
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        //return it
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //configure the state of the cell based on the properties that it represents
        let cardCell = cell as? CardCollectionViewCell
        
        //get the card from the card array
        let card = cardsArray[indexPath.row]
        
        //  finish configuring the cell
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there is time remaining, dont let the user interact with the cards if there is no time.
        if milliseconds <= 0 {
            return
        }
        
        //get a reference to the cell that was tapped
        let cell =  collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //check the status of the card to determine how to flip it.
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            
            //flip the card up
            cell?.flipUp()
            
            // play  sound
            soundPlayer.playSound(effect: .flip)
            
            //check if this card was the first card that was flipped or the second card
            if firstFlippedCardIndex == nil{
                
                //this is the first card that was flipped over
                firstFlippedCardIndex = indexPath
                
            }
            else{
                
                //second card that is flipped
                
                //run the comparison logic
                checkForMatch(indexPath)
                
            }
        }
        
    }
    //MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath){
        
        // Get the two card objects for the two indicies and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        //get the two collectionview cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName{
            
            //it's a match
            
            // play match sounds
            soundPlayer.playSound(effect: .match)
            
            //set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            //was that the last pair
            checkForGameEnd()
        }
        else{
            //it's not a match
            
            // play nomatch sounds
            soundPlayer.playSound(effect: .nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        //reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd(){
        
        //check if there any card that is unmatched
        //assume the user has won, loop through all the cards to see if they are matched
        var hasWon = true
        
        for card in cardsArray {
            if card.isMatched == false{
                //we've found a card that is unmatched
                hasWon = false
                break
            }
        }
        if hasWon == true{
            
            //user has won, show an alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
        }
        else{
            
            //user hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
            }
        }
    }
    func showAlert(title:String, message:String){
        
        //create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add an alert for the user to dismiss it.
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        //show the alert
        present(alert, animated: true, completion: nil)
        
    }
    
}


