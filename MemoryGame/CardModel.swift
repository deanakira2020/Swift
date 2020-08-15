import Foundation

class CardModel {
    
    func getCards() -> [Card]{
        
        //declare an empty array to store the numbers we've generated
        var generatedNumbers = [Int]()
        
        
        // declare an empty array to store all the cards
        var generatedCards = [Card]()
        
        // randomly generate 8 pairs of cards
        while generatedNumbers.count < 8 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                    
                // Create two new card objects
                let cardOne = Card()
                let cardTwo = Card()
                
                // Set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add them to the array
                generatedCards += [cardOne, cardTwo]
                
                //add this number to the list of generated numbers
                generatedNumbers.append(randomNumber)
                
                print(randomNumber)
        }
        }
        
        // randomize the cards within the array
        generatedCards.shuffle()
        // return the array
        return generatedCards
    }
    
}
