import UIKit
//import MapKit
import CoreLocation
//import Cosmos


class ViewController: UIViewController, MTMapViewDelegate {
 //   @IBOutlet var mapView: MTMapView?
    //@IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(imageLiteralResourceName: "background2"))
 //       self.presentingViewController?.inputViewController.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BM DoHyeon OTF", size: 12)!]
    }
    
    
}

