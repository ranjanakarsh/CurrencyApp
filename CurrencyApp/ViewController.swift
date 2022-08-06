//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Ranjan Akarsh on 06/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var idrLabel: UILabel!
    @IBOutlet weak var inrLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!

    @IBOutlet weak var getRatesButton: UIButton!

    @IBOutlet weak var fetchIndicatorLabel: UILabel!
    
    var hasTappedFetch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchIndicatorLabel.isHidden = true
    }


    @IBAction func getRatesButton(_ sender: UIButton) {
        if self.hasTappedFetch {
            return
        }
        
        self.hasTappedFetch = true
        self.getRatesButton.isEnabled = false
        self.fetchIndicatorLabel.isHidden = false
        
        // 1. build URL session
        let urlToProcess = URL(string: (CURRENCY_URL + CURRENCY_API))
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: urlToProcess!) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "error!", message: "cannot complete your request.", preferredStyle: .alert)
                let done = UIAlertAction(title: "done", style: .cancel)
                alert.addAction(done)
                self.present(alert, animated: true)
            } else {
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, Any>
                        
                        DispatchQueue.main.async {
                            if let rates = json["rates"] as? [String: Any] {
                                // usd
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                
                                if let inr = rates["INR"] as? Double {
                                    self.inrLabel.text = "INR: \(inr)"
                                }
                                
                                if let eur = rates["EUR"] as? Double {
                                    self.eurLabel.text = "EUR: \(eur)"
                                }
                                
                                if let idr = rates["IDR"] as? Double {
                                    self.idrLabel.text = "IDR: \(idr)"
                                }
                                
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                            }
                            
                            self.fetchIndicatorLabel.isHidden = true
                            self.getRatesButton.isEnabled = true
                            self.hasTappedFetch = false
                        }
                    } catch {
                        print("received no data from response - \(error)")
                    }
                }
            }
        }
        
        task.resume()
    }
}

