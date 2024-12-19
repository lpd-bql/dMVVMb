//
//  UserVC.swift
//  dMVVMb
//
//  Created by lpd on 2024/12/19.
//

import UIKit
import Combine

class UserVC: UIViewController{
    
    private var vm: UserViewModel!
    
    private var cancellables = Set<AnyCancellable>()

    lazy var nameLb: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 布局
        
        // 绑定vm
        bindViewModel()
    }
    
    // 外界配置、传递vm
    public func config(vm: UserViewModel){
        self.vm = vm
    }
    
    private func bindViewModel(){
        // 订阅 数据变化，改变UI
        vm.$userName
            .sink {[weak self] name in
                self?.nameLb.text = name
            }
            .store(in: &cancellables)
        
        vm.$formattedUserAge
            .sink {[weak self] ageStr in
                self?.nameLb.text = ageStr
            }
            .store(in: &cancellables)
    }
}
