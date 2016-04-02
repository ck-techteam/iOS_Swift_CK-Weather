//
//  WeatherReportViewController.swift
//  CK Weather
//
//  Created by Apple on 02/04/16.
//  Copyright © 2016 Armor. All rights reserved.
//

import UIKit

import CoreLocation

class WeatherReportViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var lblReports: UILabel!
    
    @IBOutlet weak var lblWeather: UILabel!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var btnGoBack: UIButton!
    
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblReports.font = UIFont(name: "MyriadSetPro-Thin", size: 30)
        
        lblWeather.font = UIFont(name: "MyriadSetPro-Thin", size: 25)
        
        lblTemperature.font = UIFont(name: "MyriadSetPro-Thin", size: 20)
        
        btnGoBack.titleLabel?.font = UIFont(name: "MyriadSetPro-Thin", size: 18)
        
        btnGoBack.layer.cornerRadius = 5.0
        
        btnGoBack.layer.masksToBounds = true
        
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error while updating location " + error.localizedDescription)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("lat" , manager.location!.coordinate.latitude)
        
        print("long" , manager.location!.coordinate.longitude)
        
        
        getWeatherData("http://api.wunderground.com/api/b8e924a8f008b81e/conditions/forecast/alert/q/\(manager.location!.coordinate.latitude),\(manager.location!.coordinate.longitude).json")
    }
    
    func getWeatherData(urlString: String)
    {
        
        let url = NSURL(string: urlString)
        
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(),
                           {
                            self.setLabels(data!)
                            
            })
            
        }
        task.resume()
    }
    
    
    func setLabels(weatherData: NSData)
    {
        
        do
        {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(weatherData, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
            
            print(jsonDict)
            
            let  cityname = jsonDict?.valueForKeyPath("current_observation.display_location.full")
            
            let  weather = jsonDict?.valueForKeyPath("current_observation.weather")
            
            let  temp = jsonDict?.valueForKeyPath("current_observation.temperature_string")
            
            let imageURL = jsonDict?.valueForKeyPath("current_observation.icon_url") as! String
            
            self.downloadImage(NSURL(string:imageURL)!);
            
            
            lblReports.text = "\(cityname!)"
            
            lblWeather.text = "\(weather!)"
            
            lblTemperature.text = "\(temp!)"
            
        } catch let error as NSError
        {
            // error handling
            print(error)
        }
        
    }
    
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imgWeather.image = UIImage(data: data)
            }
        }
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
