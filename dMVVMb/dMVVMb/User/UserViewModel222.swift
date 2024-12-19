//
//  ddddd.swift
//  dMVVMb
//
//  Created by lpd on 2024/12/19.
//


import Foundation
import Combine


class UserViewModel22: ObservableObject{
    
    // 输入属性
    @Published var userName: String = ""
    @Published var userAge: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // 输出属性
    @Published private(set) var formattedUserAge: String = ""

    
    // 网络
    private var userService: UserService
      
    
    init(userService: UserService){
        self.userService = userService
        
        // 请求
        fetchUserData()
    }
    
    func fetchUserData(){
        
        userService.fetchUser()
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("")
                }
            } receiveValue: { [weak self] user in
                // 更新数据，变化
                self?.userAge = user.age
            }
            .store(in: &cancellables)


        
        
    }
    
    
    
}
