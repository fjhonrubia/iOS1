//
//  Functions.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 27/11/15.
//
//

import UIKit


func obtainTags(arrayOfBooks : [AGTBook]) -> [String] {
    
    var tags = [String]()
    
    //Se recorren todos los AGTBooks
    for book in arrayOfBooks {
        
        //Se recorren todos los Tags del objeto AGTBook
        for tag in book.tags {
            
            //Se comprueba si el tag ya se encontraba dado de alta
            if tags.indexOf(tag) == nil {
                
                //Se añade el tag al array
                tags.append(tag)
                
            }
        }
    }
    
    return tags
}

func obtainFavorites(arrayOfBooks: [AGTBook]) -> [Int] {
    
    var favorites = [Int]()
    
    for (index,value) in arrayOfBooks.enumerate() {
        
        if value.isFavorite == true {
            favorites.append(index)
        }
        
    }
    
    return favorites
}

func readImage(fileName : String) -> UIImage? {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let imgArchive = paths[0].stringByAppendingString("/images/" + fileName)
    
    if let data = NSData(contentsOfFile: imgArchive),
        bookImage = UIImage(data: data) {
            
            return bookImage
            
    }
    
    return nil
    
}
