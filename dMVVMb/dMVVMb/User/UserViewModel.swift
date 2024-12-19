//
//  UserViewModel.swift
//  dMVVMb
//
//  Created by lpd on 2024/12/19.
//

import Foundation
import Combine

class UserViewModel: ObservableObject{
    
    // 输入属性
    @Published var userName: String = ""
    @Published var userAge: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    // 输出属性
    @Published private(set) var formattedUserAge: String = ""

    
    // 模型
    private var user: UserModel
      
    init(user: UserModel){
        self.user = user
        self.userName = user.name
        self.userAge = user.age
        
        // 绑定
        setupBind()
    }
    
    func setupBind(){
        // 监听变化
        $userAge.map { "\($0) 岁" }   //map 做数据处理
            .assign(to: \.formattedUserAge, on: self)
            .store(in: &cancellables)
        
        
    }
    
    
    
}
