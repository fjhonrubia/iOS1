//
//  MasterViewController.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 4/12/15.
//
//

import UIKit

//MARK: - Protocols

protocol BookSelectionDelegate: class {
    func bookSelected(newBook: AGTBook, model aModel: AGTLibrary)
}

//MARK: - Class

class MasterViewController: UITableViewController {
    
    var model : AGTLibrary?
    weak var delegate: BookSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Se suscribe a las notificaciones
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateLibrary", name: favoriteSwitchChangeKey, object: nil)

        if let _ = defaults.stringForKey("firstTime") {
            
            //En lugar de recoger los valores del JSON, se recogen de local
            model = AGTLibrary()
            
        } else {
            //Se guarda la propiedad fisrtTime y se le establece el valor de YES para indicar que el programa ya se ha iniciado
            defaults.setObject("YES", forKey: "firstTime")
            
            if let resourcesURL = NSURL(string: "https://t.co/K9ziV0z3SJ"),
                let data = NSData(contentsOfURL: resourcesURL) {
                    
                    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    
                    let writePath = paths[0].stringByAppendingString("/books.json")
                    
                    data.writeToFile(writePath, atomically: true)
                    
                    //Se deben crear los directorios images y pdf dentro de Documents
                    
                    let imagesPath = paths[0].stringByAppendingString("/images")
                    let pdfPath = paths[0].stringByAppendingString("/pdf")
                    
                    let filemanager = NSFileManager.defaultManager()
                    do {
                        try filemanager.createDirectoryAtPath(imagesPath, withIntermediateDirectories: false, attributes: nil)
                        try filemanager.createDirectoryAtPath(pdfPath, withIntermediateDirectories: false, attributes: nil)
                    } catch {
                        print("Error al crear los directorios para las imágenes y los pdf")
                    }
                    
                    do {
                        if let data = NSData(contentsOfFile: writePath),
                            jsons = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray {
                                
                                model = AGTLibrary(arrayOfBooks: jsons)
                                model?.saveChanges()
                        }
                    } catch {
                        print("Ocurrió un error a la hora de crear el modelo")
                    }
            }
            
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = model?.tags.count {
            if model?.favorites?.count == 0 {
                return sections
            } else {
                return sections + 1
            }
        } else {
            return 0
        }
        
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            var sec : Int = 0
            
            //Lo primero que hay que hacer es ver en que sección se está
        
            if (section == 0) && (model?.favorites?.count != 0) {
                return (model?.favorites?.count)!
            } else {
                //Se obtiene el tag del model
                if model?.favorites?.count == 0 {
                    sec = section
                } else {
                    sec = section - 1
                }
                if let tag = model?.tags[sec] {
                    
                    //Ahora se retorna el valor del método booksForTag
                    return (model?.booksForTag(tag).c)!
                    
                } else {
                    return 0
                }
            }
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            
            var sec = 0
            
            if (section == 0) && (model?.favorites?.count != 0) {
                return "FAVORITOS"
            } else {
                if model?.favorites?.count == 0 {
                    sec = section
                } else {
                    sec = section - 1
                }
                return model?.tags[sec].uppercaseString
            }
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cellID = "BookCellID"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
            var sec = 0
            
            if cell == nil{
                // Se crea la celda
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
            }
            
            if (indexPath.section == 0) && (model?.favorites?.count != 0) {
                
                let indexBook = model?.favorites![indexPath.row]
                let favoriteBook = model?.books[indexBook!]
                cell?.textLabel?.text = favoriteBook?.title
                cell?.detailTextLabel?.text = favoriteBook?.authors.joinWithSeparator(",")
                
                cell?.imageView?.image = readImage((favoriteBook?.imgURL.absoluteString)!)
                
            } else {
                
                if model?.favorites?.count == 0 {
                    sec = indexPath.section
                } else {
                    sec = indexPath.section - 1
                }
                
                //Se obtiene el tag
                let tag = model?.tags[sec]
                
                // Se obtiene el libro
                let book = model?.bookAtIndex(indexPath.row, forTag: tag)
                
                // Se configura la celda
                cell?.textLabel?.text = book?.title
                cell?.detailTextLabel?.text = book?.authors.joinWithSeparator(",")
                
                cell?.imageView?.image = readImage((book?.imgURL.absoluteString)!)
            }

            return cell!
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tag : String?
        let selectedBook : AGTBook?
        var sec = 0
        
        //Se comprueba la sección en la que se ha seleccionado el libro
        if (indexPath.section == 0) && (model?.favorites?.count != 0) {
            
            //No hace falta obtener el tag porque se trata de un libro marcado como favorito
            let indexBook = model?.favorites![indexPath.row]
            selectedBook = model?.books[indexBook!]
            
            //Se establece el delegado
            self.delegate?.bookSelected(selectedBook!, model: model!)
            
        } else {
            
            if model?.favorites?.count == 0 {
                sec = indexPath.section
            } else {
                sec = indexPath.section - 1
            }
            
            //Se obtiene el tag
            tag = model?.tags[sec]
            
            // Se obtiene el libro
            selectedBook = model?.bookAtIndex(indexPath.row, forTag: tag)
            
            //Se establece el delegado
            self.delegate?.bookSelected(selectedBook!, model: model!)
        }
        
        //Se muestra la vista de detalle del libro        
        if let detailViewController = self.delegate as? DetailViewController {
            detailViewController.navigationController?.popToRootViewControllerAnimated(true)
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
        
        //Se almacena el libro seleccionado para rescatarlo en caso de que se salga de la aplicación
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(selectedBook!)
        defaults.setObject(encodedData, forKey: "selectedBook")
    }
    
    //MARK: - Functions
    func updateLibrary() {
        model?.saveChanges()
        model?.favorites = obtainFavorites((model?.books)!)
        self.tableView.reloadData()
    }

}
