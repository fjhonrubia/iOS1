//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 22/11/15.
//
//

import Foundation

enum BookFields: String {
    case title
    case authors
    case tags
    case imgURL
    case pdfURL
    case isFavorite
}

class AGTBook: NSObject, NSCoding, Comparable {
    
    let title : String
    let authors: [String]
    let tags: [String]
    let imgURL: NSURL
    let pdfURL: NSURL
    var isFavorite = false
    
    //MARK: - Initialization
    
    //Inicializador designado de la clase
    init(title: String,
        authors: [String],
        tags: [String],
        imgURL: NSURL,
        pdfURL: NSURL) {
            
            self.title = title
            self.authors = authors
            self.tags = tags
            self.imgURL = imgURL
            self.pdfURL = pdfURL
    }
    
    //MARK: - Archiving
    
    required init?(coder aDecoder: NSCoder) {
        
        if let title = aDecoder.decodeObjectForKey(BookFields.title.rawValue) as? String {
            self.title = title
        } else {
            self.title = "No title"
        }
        
        if let authors = aDecoder.decodeObjectForKey(BookFields.authors.rawValue) as? [String] {
            self.authors = authors
        } else {
            self.authors = [String]()
        }
        
        if let tags = aDecoder.decodeObjectForKey(BookFields.tags.rawValue) as? [String] {
            self.tags = tags
        } else {
            self.tags = [String]()
        }
        
        if let imgURL = aDecoder.decodeObjectForKey(BookFields.imgURL.rawValue) as? NSURL {
            self.imgURL = imgURL
        }
        else {
            self.imgURL = NSURL.init()
        }
        
        if let pdfURL = aDecoder.decodeObjectForKey(BookFields.pdfURL.rawValue) as? NSURL {
            self.pdfURL = pdfURL
        } else {
            self.pdfURL = NSURL.init()
        }
        
        self.isFavorite = aDecoder.decodeBoolForKey(BookFields.isFavorite.rawValue)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.title, forKey: BookFields.title.rawValue)
        aCoder.encodeObject(self.authors, forKey: BookFields.authors.rawValue)
        aCoder.encodeObject(self.tags, forKey: BookFields.tags.rawValue)
        aCoder.encodeObject(self.imgURL, forKey: BookFields.imgURL.rawValue)
        aCoder.encodeObject(self.pdfURL, forKey: BookFields.pdfURL.rawValue)
        aCoder.encodeBool(self.isFavorite, forKey: BookFields.isFavorite.rawValue)
        
    }
    
}

//MARK: - Operators

func ==(lhs: AGTBook, rhs: AGTBook) -> Bool {
    
    //Se comprueba si son el mismo objeto
    guard !(lhs === rhs) else {
        return true
    }
    
    //Se comprueba si sus clases son distintas
    guard lhs.dynamicType == rhs.dynamicType else {
        return false
    }
    
    //En este caso únicamente va a comprobarse el título del libro
    return (lhs.title == rhs.title)
}

func <(lhs: AGTBook, rhs: AGTBook) -> Bool {
    
    //La ordenación se hará por el título del libro
    return (lhs.title < rhs.title)
}

