class Comment : Hashable{
    let author: String
    let postid: String
    let body: String
    let date: String
    let downvotes: Int
    let upvotes: Int
    var hashValue: Int
    
    init(author: String, postid: String, body: String, date: String, downvotes: Int, upvotes: Int) {
        self.author = author;
        self.postid = postid;
        self.body = body;
        self.date = date;
        self.downvotes = downvotes;
        self.upvotes = upvotes;
        self.hashValue = 0;
    }
    
    public static func ==(lhs: Comment, rhs: Comment) -> Bool {
        if lhs.body == rhs.body {
            return true;
        }
        return false;
    }
}

extension Comment {
    
    convenience init(json: Dictionary<String, Any>) throws {
        guard let author = json["author"] as? String else {
            throw Service.Error.missingJsonProperty(name: "author")
        }
        guard let postid = json["post"] as? String else {
            throw Service.Error.missingJsonProperty(name: "post")
        }
        guard let body = json["body"] as? String else {
            throw Service.Error.missingJsonProperty(name: "body")
        }
        guard let date = json["date"] as? String else {
            throw Service.Error.missingJsonProperty(name: "date")
        }
        guard let downvotes = json["downvotes"] as? Int else {
            throw Service.Error.missingJsonProperty(name: "downvotes")
        }
        guard let upvotes = json["upvotes"] as? Int else {
            throw Service.Error.missingJsonProperty(name: "upvotes")
        }
        self.init(author: author, postid: postid, body: body, date: date, downvotes: downvotes, upvotes: upvotes);
    }
}
