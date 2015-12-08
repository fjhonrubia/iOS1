//
//  AGTSimplePDFViewController.swift
//  HackerBooks
//
//  Created by Fco. Javier Honrubia Lopez on 7/12/15.
//
//

import UIKit

class AGTSimplePDFViewController: UIViewController {
    
    var book : AGTBook?
    @IBOutlet weak var PDFWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Se obtiene el libro de la URL que tiene
        let request = NSURLRequest(URL: (book?.pdfURL)!)
            
        //Se le pasa el UIWebViewController para que lo cargue
        PDFWebView.loadRequest(request)
        
    }
}
