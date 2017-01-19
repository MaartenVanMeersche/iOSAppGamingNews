import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var color: UIColor?
    
    override func viewDidLoad() {
        if(color != nil){
            colorView.backgroundColor = color
            let ciColor = CIColor(color: color!)
            redSlider.value = Float(ciColor.red)
            greenSlider.value = Float(ciColor.green)
            blueSlider.value = Float(ciColor.blue)
        }
        updatePreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(color != nil){
            colorView.backgroundColor = color
            let ciColor = CIColor(color: color!)
            redSlider.value = Float(ciColor.red)
            greenSlider.value = Float(ciColor.green)
            blueSlider.value = Float(ciColor.blue)
        }
    }
    
    @IBAction func updatePreview() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    @IBAction func save() {
            let red = Float(redSlider.value)
            let green = Float(greenSlider.value)
            let blue = Float(blueSlider.value)
            color = UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
            performSegue(withIdentifier: "changeColor", sender: self)
    }
}
