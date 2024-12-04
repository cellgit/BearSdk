//
//  RequestMapper.swift
//  Tenant
//
//  Created by liuhongli on 2024/4/4.
//

import Foundation
import Combine
import Moya
import SwiftData


enum BusinessError: Error {
    case business(code: Int, message: String?)
}

//内部错误
public enum InsideError: Error {
    //服务器返回的格式不对,解析不到result和code字段
    case formatterError
}

public extension AnyPublisher where Output == Response, Failure == MoyaError {
    
    func mapResult<T: Decodable>() -> AnyPublisher<T, MoyaError> {
        self.flatMap { response -> AnyPublisher<T, MoyaError> in
            // 尝试解析JSON数据
            guard let json = try? response.mapJSON() as? [String: Any],
                  let code = json["code"] as? Int else {
                // 数据格式不正确，抛出内部错误
                let formatterError = MoyaError.underlying(InsideError.formatterError, nil)
                return Fail(error: formatterError).eraseToAnyPublisher()
            }
            // 检查业务逻辑错误
            guard code == 200, let resultData = json["result"] else {
                let message = json["message"] as? String ?? "Unknown error"
                let businessError = MoyaError.underlying(BusinessError.business(code: code, message: message), nil)
                return Fail(error: businessError).eraseToAnyPublisher()
            }
            
            // 尝试将结果转换为目标类型
            do {
                let result = try JSONSerialization.data(withJSONObject: resultData)
                let decodedResult = try JSONDecoder().decode(T.self, from: result)
                return Just(decodedResult)
                    .setFailureType(to: MoyaError.self)
                    .eraseToAnyPublisher()
            } catch {
                let decodeError = MoyaError.underlying(error, nil)
                return Fail(error: decodeError).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    // 针对SwiftData的mapResult
    func mapResultSwiftData() -> AnyPublisher<Any?, MoyaError> {
        self.tryMap { (response: Response) -> Any? in
            // 尝试解析JSON数据
            guard let json = try? response.mapJSON() as? [String: Any],
                  let code = json["code"] as? Int else {
                // 如果数据格式不正确，抛出内部错误
                throw InsideError.formatterError
            }
            // 根据业务逻辑处理错误
            guard code == 200 else {
                let message = json["message"] as? String
                // 抛出业务错误
                throw BusinessError.business(code: code, message: message)
            }
            // 如果成功，返回结果
            return json["result"]
        }
        // 处理转换过程中的错误，将它们转换为MoyaError
        .mapError { error -> MoyaError in
            // 这里简单地将所有错误转换为`MoyaError.underlying`，
            // 你可以根据需要进行更精细的错误处理和转换
            return MoyaError.underlying(error, nil)
        }
        .eraseToAnyPublisher()
    }
    
    // 调用 `mapResultSwiftData`,给出完整代码

    // provider.requestPublisher(.subwayLines(city))





    // provider.requestPublisher(.subwayLines(city))
    //     .mapResultSwiftData()
    //     .map { (result: Any?) -> [SubwayLine] in

    

    
    
}


//public extension AnyPublisher where Output == Response, Failure == MoyaError {
//
//    func mapResult() -> AnyPublisher<Any?, MoyaError> {
//        self.tryMap { (response: Response) -> Any? in
//            // 尝试解析JSON数据
//            guard let json = try? response.mapJSON() as? [String: Any],
//                  let code = json["code"] as? Int else {
//                // 如果数据格式不正确，抛出内部错误
//                throw InsideError.formatterError
//            }
//            // 根据业务逻辑处理错误
//            guard code == 0 else {
//                let message = json["message"] as? String
//                // 抛出业务错误
//                throw BusinessError.business(code: code, message: message)
//            }
//            // 如果成功，返回结果
//            return json["result"]
//        }
//        // 处理转换过程中的错误，将它们转换为MoyaError
//        .mapError { error -> MoyaError in
//            // 这里简单地将所有错误转换为`MoyaError.underlying`，
//            // 你可以根据需要进行更精细的错误处理和转换
//            return MoyaError.underlying(error, nil)
//        }
//        .eraseToAnyPublisher()
//    }
//}


//
//public extension Publisher where Output == Response, Failure == MoyaError {
//    
//    func mapResult<T: Decodable>() -> AnyPublisher<T, MoyaError> {
//        self.flatMap { response -> AnyPublisher<T, MoyaError> in
//            // 尝试解析JSON数据
//            guard let json = try? response.mapJSON() as? [String: Any],
//                  let code = json["code"] as? Int else {
//                // 数据格式不正确，抛出内部错误
//                let formatterError = MoyaError.underlying(InsideError.formatterError, nil)
//                return Fail(error: formatterError).eraseToAnyPublisher()
//            }
//            
//            // 检查业务逻辑错误
//            guard code == 0, let resultData = json["result"] else {
//                let message = json["message"] as? String ?? "Unknown error"
//                let businessError = MoyaError.underlying(BusinessError.business(code: code, message: message), nil)
//                return Fail(error: businessError).eraseToAnyPublisher()
//            }
//            
//            // 尝试将结果转换为目标类型
//            do {
//                let result = try JSONSerialization.data(withJSONObject: resultData)
//                let decodedResult = try JSONDecoder().decode(T.self, from: result)
//                return Just(decodedResult)
//                    .setFailureType(to: MoyaError.self)
//                    .eraseToAnyPublisher()
//            } catch {
//                let decodeError = MoyaError.underlying(error, nil)
//                return Fail(error: decodeError).eraseToAnyPublisher()
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
//
//
//public extension Publisher where Output == Response, Failure == MoyaError {
//    
//    func mapResult<T: Decodable>() -> AnyPublisher<T, MoyaError> {
//        flatMap { response -> AnyPublisher<T, MoyaError> in
//            do {
//                // 尝试将响应的JSON数据解析到中间类型
//                let jsonResponse = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
//                
//                // 检查业务逻辑错误
//                if let code = jsonResponse?["code"] as? Int, code != 0 {
//                    let message = jsonResponse?["message"] as? String ?? "Unknown business logic error"
//                    // 抛出业务错误
//                    throw MoyaError.underlying(BusinessError.business(code: code, message: message), nil)
//                }
//                
//                // 从响应中提取result字段并解码为目标类型T
//                if let resultData = jsonResponse?["result"], let resultJSON = try? JSONSerialization.data(withJSONObject: resultData) {
//                    let decodedResult = try JSONDecoder().decode(T.self, from: resultJSON)
//                    return Just(decodedResult).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
//                } else {
//                    throw MoyaError.underlying(InsideError.formatterError, nil)
//                }
//            } catch let error as MoyaError {
//                return Fail(error: error).eraseToAnyPublisher()
//            } catch {
//                // 将其他错误转换为MoyaError
//                return Fail(error: MoyaError.underlying(error, nil)).eraseToAnyPublisher()
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}



