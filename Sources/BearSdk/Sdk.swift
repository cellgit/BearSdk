import Alamofire

public struct BearSdk {
    public static func makeRequest() {
        
        debugPrint("makeRequest===")
        
        AF.request("https://api.github.com").response { response in
            debugPrint("response === \(response)")
        }
    }
}
