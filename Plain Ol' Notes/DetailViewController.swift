//
//  DetailViewController.swift
//  Plain Ol' Notes
//
//  Created by Amartya Banerjee on 1/29/16.
//  Copyright © 2016 Northwestern University. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UITextView!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if objects.count == 0{
            return
        }
        
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            if label.text == BLANK_NOTE{
                label.text = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detailViewController = self
        
        //First responder refers to the first object to receive events, now since we're applying this to a text view, we're talking about keyboard input. When we call this on a text view, this also, in addition to setting this text field as the object to receive keyboard input, it also pops up the keyboard
        detailDescriptionLabel.becomeFirstResponder()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

