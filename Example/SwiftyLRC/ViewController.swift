//
//  ViewController.swift
//  SwiftyLRC
//
//  Created by M-H-N on 07/07/2023.
//  Copyright (c) 2023 M-H-N. All rights reserved.
//

import UIKit
import SwiftyLRC

class ViewController: UIViewController {
    
    @IBOutlet weak var txtMain: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.useLRC()
    }

    
    private func useLRC() {
        let filePath = Bundle.main.path(forResource: "lrc-0", ofType: "txt")!
        let fileContent = try! String(contentsOfFile: filePath)
        
        let lrc = LRC.Parser.parse(lrcString: fileContent)
        
        self.txtMain.text = ""
        
        self.txtMain.text = lrc?.tags
            .map({ $0.name + " : " + $0.content + "\n" })
            .reduce("", +)
        
        self.txtMain.text.append("\n\n\n\n")
        
        lrc?.lines
            .map({ $0.time.description + " --> " + $0.text + "\n" })
            .forEach({ self.txtMain.text.append($0) })
    }

}

