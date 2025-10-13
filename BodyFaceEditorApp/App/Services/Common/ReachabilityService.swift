import Foundation
import Network

class ReachabilityService {
    
    static let shared = ReachabilityService()
    private init() {}
    
    func checkNetworkStatusAsync() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "NetworkMonitor")
            
            monitor.pathUpdateHandler = { path in
                let isConnected = path.status == .satisfied
                monitor.cancel()
                continuation.resume(returning: isConnected)
            }
            
            monitor.start(queue: queue)
        }
    }
}

