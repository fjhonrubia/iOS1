//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 27/11/15.
//
//

import Foundation

class AGTLibrary {
    
    //MARK: - Properties
    
    //Propiedades que contienen una colección de todos los libros y todos los tags
    var books : [AGTBook]
    var tags : [String]
    var favorites : [Int]?
    
    //Propiedad computada
    var booksCount: Int{
        get{
            let count : Int = self.books.count
            return count
        }
    }
    
    //MARK: - Initialization
    init(arrayOfBooks : JSONArray) {
        
        books = decode(books: arrayOfBooks).sort({$0 < $1})
        tags = obtainTags(books).sort({$0 < $1})
        favorites = obtainFavorites(books)
        
    }
    
    //MARK: - Archiving
    
    init() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let booksArchive = paths[0].stringByAppendingString("/books.archive")
        
        books = NSKeyedUnarchiver.unarchiveObjectWithFile(booksArchive) as! [AGTBook]
        
        books = books.sort({$0 < $1})

        tags = obtainTags(books).sort({$0 < $1})
        favorites = obtainFavorites(books)
        
    }
    
    func saveChanges() -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let booksArchive = paths[0].stringByAppendingString("/books.archive")
        
        
        return NSKeyedArchiver.archiveRootObject(self.books, toFile: booksArchive)
    }
    
    //MARK: - Methods
    
    func booksForTag(tag: String?) -> (c: Int, b: [AGTBook]?) {
        
        guard tag != nil else{
            return (0,nil)
        }
        
        let t = tag!
        var count : Int = 0
        var arrayOfBooks = [AGTBook]()
        
        //Se recorre el Array de AGTBooks contando cada libro por el tag pasado
        for book in books {
         
            if book.tags.indexOf(t) != nil {
                ++count
                arrayOfBooks.append(book)
            }
        }
        
        return (count, arrayOfBooks)
    }
    
    func bookAtIndex(index : Int, forTag tag: String?) -> AGTBook? {
        
        //Se comprueba si el tag es nil
        guard tag != nil else {
            return nil
        }
        
        let t = tag!
        
        //Se comprueba si el tag está dentro del array
        guard tags.indexOf(t) != nil else {
            return nil
        }
        
        //Si el tag existe, se obtienen los AGTBooks asociados a él
        var booksXTag = booksForTag(t)
        
        //Si el número de libros encontrado es 0 se retorna nil
        guard booksXTag.c != 0 else {
            return nil
        }
        
        //Si el índice es mayor o igual que el número de libros se retorna nil
        guard booksXTag.c >= index else {
            return nil
        }
        
        //Se retorna el libro especificado
        return booksXTag.b?[index]
    }

}
