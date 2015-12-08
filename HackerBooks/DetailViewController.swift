//
//  DetailViewController.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 5/12/15.
//
//

import UIKit

let favoriteSwitchChangeKey = "favoriteSwitchChangeKey"

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var mainStackView: UIStackView!
    
    var model : AGTLibrary?
    
    var book: AGTBook! {
        didSet (newBook) {
            self.refreshUI()
        }
    }
    
    func refreshUI(){
        mainStackView.hidden = false
        titleLabel?.text = book.title
        authorsLabel?.text = book.authors.joinWithSeparator(",")
        tagsLabel?.text = book.tags.joinWithSeparator(",")
        coverView?.image = readImage(book.imgURL.absoluteString)
        if book.isFavorite {
            favoriteSwitch.setOn(true, animated: true)
        } else {
            favoriteSwitch.setOn(false, animated: true)
        }
        
    }
    
    func stateChanged(switchState: UISwitch) {
        let index = model?.books.indexOf(book)
        model?.books[index!].isFavorite = favoriteSwitch.on
        NSNotificationCenter.defaultCenter().postNotificationName(favoriteSwitchChangeKey, object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = defaults.objectForKey("selectedBook") as? NSData ,
            let lastBook = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? AGTBook {
            book = lastBook
            refreshUI()
        } else {
            mainStackView.hidden = true
        }
        
    }

    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Comprobación del identificación del segue
        if segue.identifier == "showPDF" {
            
            //Se obtiene el segue correspondiente
            let PDFVC = segue.destinationViewController as? AGTSimplePDFViewController
            
            //Se asigna el libro al controller
            PDFVC?.book = self.book
        }
    }
}

//MARK: - Extensions

extension DetailViewController: BookSelectionDelegate {
    func bookSelected(newBook: AGTBook, model aModel: AGTLibrary) {
        book = newBook
        model = aModel
    }
}
