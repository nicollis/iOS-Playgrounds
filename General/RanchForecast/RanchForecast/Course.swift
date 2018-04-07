
import Foundation

class Course: NSObject {
    let title: String
    let url: URL
    let nextStartDate: Date
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    var nextStartDateString: String {
        return dateFormatter.string(from: nextStartDate)
    }
    
    init(title: String, url: URL, nextStartDate: Date) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
    
    public static func ==(lhs: Course, rhs: Course) -> Bool {
        if lhs.title == rhs.title,
        lhs.url == rhs.url,
        lhs.nextStartDate == rhs.nextStartDate {
            return true
        }
        return false
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Course else { return false }
        return self == other
    }
}

extension Course {
    override var description: String {
        return "<Course: \"\(title)\" on \(nextStartDateString) via \(url.lastPathComponent)>"
    }
}
