//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 22/11/15.
//
//

import UIKit

//MARK: Enums
enum fieldsNames: String {
    case title
    case authors
    case tags
    case image_url
    case pdf_url
}

//MARK: - Aliases
typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String:JSONObject]
typealias JSONArray         = [JSONDictionary]

//MARK: - Errors
enum JSONProcessingError : ErrorType{
    case WrongURLFormatForJSONResource
    case ResourcePointedByURLNotReachable
    case JSONParsingError
    case WrongJSONFormat
}

//MARK: - Resources
enum typesOfResources: String {
    case image
    case pdf
}

func decode(book json: JSONDictionary) throws -> AGTBook {
    
    //Se comprueba que existe el título del libro
    guard let title = json[fieldsNames.title.rawValue] as? String else {
        throw JSONProcessingError.WrongJSONFormat
    }
    
    //Se comprueba que existe por lo menos algún autor
    guard let authors = json[fieldsNames.authors.rawValue] as? String else {
        throw JSONProcessingError.WrongJSONFormat
    }
    
    //Se comprueba también que existe algún tag
    guard let tags = json[fieldsNames.tags.rawValue] as? String else {
        throw JSONProcessingError.WrongJSONFormat
    }
    
    //Se comprueba que existe una URL para la imagen del libro y que es una URL válida
    guard let imgUrlJSON = json[fieldsNames.image_url.rawValue] as? String,
        imgUrl = NSURL(string: imgUrlJSON) else {
            throw JSONProcessingError.ResourcePointedByURLNotReachable
    }
    
    //Por último también se comprueba que existe una URL para el pdf y que es válida
    guard let pdfUrlJSON = json[fieldsNames.pdf_url.rawValue] as? String,
        pdfUrl = NSURL (string: pdfUrlJSON) else {
            throw JSONProcessingError.ResourcePointedByURLNotReachable
    }
    
    //Se va a almacenar la imagen del libro directamente en el directorio Documents/images
    guard let imgLocalURL = saveResource(imgUrl, typeOfResource: .image) else {
        throw JSONProcessingError.JSONParsingError
    }
    
    //Aquí ya puede retornarse el objeto AGTBook correctamente inicializado y apuntando a los recursos en local
    
    return AGTBook(title: title, authors: authors.componentsSeparatedByString(","), tags: tags.componentsSeparatedByString(","), imgURL: imgLocalURL, pdfURL: pdfUrl)
    
    
}

func decode(books json: JSONArray) -> [AGTBook] {
    
    var library = [AGTBook]()
    
    //Se recorre el array de entrada decodificando cada elemento y anexándolo al array
    //CAMBIAR POR LA FUNCIÓN MAP
    do {
        for each in json {
            
            library.append(try decode(book: each))
        }
        
        return library
        
    } catch {
        fatalError("Error en el parseo del JSON")
    }
}

//Función para almacenar las imágenes y los pdf y retornar en un string su path
private func saveResource(rscURL: NSURL, typeOfResource type: typesOfResources) -> NSURL? {

    if let data = NSData(contentsOfURL: rscURL) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let fileName = rscURL.lastPathComponent
        var resourcePath = ""
        
        switch type {
        case .image:
            resourcePath = paths[0].stringByAppendingString("/images")
        case .pdf:
            resourcePath = paths[0].stringByAppendingString("/pdf")
        }
        
        resourcePath = resourcePath.stringByAppendingString("/" + fileName!)
        data.writeToFile(resourcePath, atomically: true)

        return NSURL(string: fileName!)
        
    } else {
        return nil
    }

}







