import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var settings: Bool = false
    var colorBar: UIColor = UIColor()
    
    fileprivate var posts: [Post] = []
    private var currentTask: URLSessionTask?
    
    override func viewDidLoad() {
        colorBar = (navigationController?.navigationBar.barTintColor)!
        
        splitViewController!.delegate = self
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(errorView)
        tableView.addConstraints([
            errorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            errorView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            errorView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        hideErrorView()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        tableView.addConstraints([
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: tableView,
                               attribute: .centerX,
                               multiplier: 1, constant: 0),
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: tableView,
                               attribute: .centerY,
                               multiplier: 1, constant: 0)
            ])
        activityIndicator.startAnimating()
        
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let posts):
                self.hideErrorView()
                self.posts = posts.sorted { $0.date < $1.date }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.tableView.reloadData()
            }
            activityIndicator.stopAnimating()
        }
        currentTask!.resume()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func showErrorView() {
        tableView.separatorStyle = .none
        errorView.isHidden = false
    }
    
    private func hideErrorView() {
        tableView.separatorStyle = .singleLine
        errorView.isHidden = true
    }
    
    func refreshTableView() {
        currentTask?.cancel()
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let posts):
                self.posts = posts.sorted { $0.date < $1.date }
                self.tableView.reloadData()
                self.hideErrorView()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.tableView.reloadData()
            }
            self.tableView.refreshControl!.endRefreshing()
        }
        currentTask!.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "posts":
            let navigationController = segue.destination as! UINavigationController
            let postViewController = navigationController.topViewController as! PostViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            postViewController.post = posts[selectedIndex]
        case "settings":
            let navigationController = segue.destination as! UINavigationController
            let settingsViewController = navigationController.topViewController as! SettingsViewController
            settingsViewController.color = colorBar
        default:
            break
        
        }
    }
    
    @IBAction func unwindFromPost(_ segue: UIStoryboardSegue) {
        let source = segue.source as! SettingsViewController
        if let color = source.color {
            navigationController?.navigationBar.barTintColor = color
            colorBar = color
        }
    }
}

extension PostsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel!.text = post.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: post.date)
        dateFormatter.dateFormat = "dd MMMM yyyy 'at' HH:mm"
        let finalDate = dateFormatter.string(from: date!)
        cell.detailTextLabel!.text = "\(finalDate) | \(post.author)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension PostsViewController: UITableViewDelegate {
    
}

extension PostsViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print(splitViewController.traitCollection)
        print(secondaryViewController.traitCollection)
        return true
    }
}
