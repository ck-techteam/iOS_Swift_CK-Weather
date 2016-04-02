//
//  ViewController.swift
//  CK Weather
//
//  Created by Apple on 02/04/16.
//  Copyright © 2016 Armor. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var btnViewWeather: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        lblWelcome.font = UIFont(name: "MyriadSetPro-Thin", size: 40)
        
        lblWelcome.text = "Welcome to\n CK\n Weather app"
        
        btnViewWeather.titleLabel?.font = UIFont(name: "MyriadSetPro-Thin", size: 18)
        
        btnViewWeather.layer.cornerRadius = 5.0
        
        btnViewWeather.layer.masksToBounds = true
        
        btnViewWeather.titleLabel?.adjustsFontSizeToFitWidth = true
        
        btnViewWeather.titleLabel?.minimumScaleFactor = 0.01
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnViewWeatherPressed(sender: AnyObject)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("WeatherReport") as! WeatherReportViewController
        
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
}

