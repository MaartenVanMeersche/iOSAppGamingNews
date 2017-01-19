import SwiftyJSON

class Post {
    
    let author: String
    let title: String
    let summary: String
    let body: String
    let link: String
    let date: String
    //let comments: [Comment]
    let downvotes: Int
    let upvotes: Int
    
    init(author: String, title: String, summary: String, body: String, link: String, date: String,// comments: [Comment],
        downvotes: Int, upvotes: Int) {
        self.author = author;
        self.title = title;
        self.summary = summary;
        self.body = body;
        self.link = link;
        self.date = date;
       // self.comments = comments;
        self.downvotes = downvotes;
        self.upvotes = upvotes;
    }
}

extension Post {
    
    convenience init(json: [String: Any]) throws {
        guard let author = json["author"] as? String else {
            throw Service.Error.missingJsonProperty(name: "author")
        }
        guard let title = json["title"] as? String else {
            throw Service.Error.missingJsonProperty(name: "author")
        }
        guard let summary = json["summary"] as? String else {
            throw Service.Error.missingJsonProperty(name: "summary")
        }
        guard let body = json["body"] as? String else {
            throw Service.Error.missingJsonProperty(name: "body")
        }
        guard let link = json["link"] as? String else {
            throw Service.Error.missingJsonProperty(name: "link")
        }
        guard let date = json["date"] as? String else {
            throw Service.Error.missingJsonProperty(name: "date")
        }
       // guard let comments = json["comments"] as? [[String:AnyObject]] else {
        //    throw Service.Error.missingJsonProperty(name: "comments")
        //}
        //var comments = [Comment]()
        //do {
            //let c = try json["comments"].map {
               //try Comment(author: $0["author"] as? String, postid: $0["postid"] as? String, body: $0["body"] as? String, date: $0["date"] as?String, downvotes: $0["downvotes"] as? Int, upvotes: $0["upvotes"] as? Int)
            //}
            //comments.append(c!)
        //}
        //for comment in comments{
        ///    guard let author = comment["author"] as! String
        //    guard let postid = comment["postid"] as! String
        //    guard let body = comment["body"] as! String
        //    guard let date = comment["date"] as! String
        //    guard let downvotes = comment["downvotes"] as! Int
        //    guard let upvotes = comment["upvotes"] as! Int
        //    guard finalComments.append(Comment(author: author, postid: postid, body: body, date: date, downvotes: downvotes, upvotes: upvotes))
        //}
        guard let downvotes = json["downvotes"] as? Int else {
            throw Service.Error.missingJsonProperty(name: "downvotes")
        }
        guard let upvotes = json["upvotes"] as? Int else {
            throw Service.Error.missingJsonProperty(name: "upvotes")
        }
        self.init(author: author, title: title, summary: summary, body: body, link: link, date: date,// comments:comments,
            downvotes: downvotes, upvotes: upvotes);
    }
}
