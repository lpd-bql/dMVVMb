//
//  UserService.swift
//  dMVVMb
//
//  Created by lpd on 2024/12/19.
//

import Foundation
import Combine

class UserService{
    
    
    
    func fetchUser() -> AnyPublisher<UserModel, Error>{
        let url = URL(string: "ddddd")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    
}
