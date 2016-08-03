/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var importedImageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func pauseAppClicked(sender: AnyObject) {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        // UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    @available(iOS 8.0, *)
    @IBAction func createAlertClicked(sender: AnyObject) {
        var alert = UIAlertController(title: "Hey There!", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func restoreAppClicked(sender: AnyObject) {
        activityIndicator.stopAnimating()
        // UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        
        print ("image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        importedImageView.image = image
    }
    
    @IBAction func importImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        var product = PFObject(className: "Products");
        product["name"] = "Ice Cream"
        product["description"] = "Vanilla"
        product["price"] = 4.99
        
        product.saveInBackgroundWithBlock { (success, error) in
            if success == true {
                print ("Object saved with ID \(product.objectId)")
            }
            else {
                print (error)
            }
        }
 */
        var query = PFQuery(className: "Products")
        query.getObjectInBackgroundWithId("EWQtw9LkOe") { (object: PFObject?, error: NSError?) in
            if error == nil {
                print(object)
                print(object!.objectForKey("description"))
                
                if let product = object {
                    product["description"] = "rocky road"
                    
                    product.saveInBackground();
                }
            }
            else {
                print (error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
