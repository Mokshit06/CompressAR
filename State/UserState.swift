import SwiftUI

public class UserState: ObservableObject {
    public init() {
        currentPage = UserDefaults.standard.integer(forKey: "current_page")
        
        if let savedCompletionProgress = UserDefaults.standard.data(forKey: "completion_progress") {
            if let decodedCompletionProgress = try? JSONDecoder().decode([String].self, from: savedCompletionProgress) {
                completionProgress = decodedCompletionProgress
                return
            }
        }
        
        completionProgress = [String]()
    }
    
    @Published public var currentPage: Int {
        didSet {
            UserDefaults.standard.set(currentPage, forKey: "current_page")
        }
    }
    
    @Published public var completionProgress: [String] {
        didSet {
            if let encoded = try? JSONEncoder().encode(completionProgress) {
                UserDefaults.standard.set(encoded, forKey: "completion_progress")
            }
        }
    }
    
    func resetCompletionProgress() {
        completionProgress = [String]()
        currentPage = 0
    }
    
    func appendToCompletionProgress(id: String) {
        if !completionProgress.contains(id) {
            completionProgress.append(id)
        }
    }
}
