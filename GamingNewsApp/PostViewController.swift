import UIKit

class PostViewController: UITableViewController {
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var btnLink: UIButton!
    
    var post: Post!
    
    override func viewDidLoad() {
        title = "Gaming News - Post"
        titelLabel.text = post.title
        bodyLabel.text = post.body
        authorLabel.text = "Gaming News - \(post.author)"
        votesLabel.text = "\(post.upvotes) vs \(post.downvotes)"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
    @IBAction func btnTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:post.link)!, options: [:], completionHandler: nil)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
