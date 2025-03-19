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
        return lb
    }()
    
    lazy var cityLb: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let btn = UIButton()
    
    var textField = UITextField()
    var inputTF = UITextField()

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
        
        // .assign 用于将数据直接绑定到对象的属性，实现数据驱动 UI
        vm.$cityName
//            .map { $0 as String? }   // assign 绑定类型 须一致
            .assign(to: \.text, on: self.cityLb)
            .store(in: &cancellables)
        
        vm.$formattedUserAge
            .sink {[weak self] ageStr in
                self?.nameLb.text = ageStr
            }
            .store(in: &cancellables)
         
        // 订阅
        vm.notificationSubject.sink { str in
            // 收到 str
        }.store(in: &cancellables)
        
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("输入：\(text)")
            }
            .store(in: &cancellables)
        
        textField.publisher(for: \.text)
            .sink { str in
                
            }
            .store(in: &cancellables)
         
        // 双向绑定  inputTF.text -> inputStr
        inputTF.publisher(for: \.text)  // 监听 UITextField 的输入
            .compactMap { $0 }            // 过滤 nil 值
            .map { String($0.prefix(20)) } // 限制最多 20 个字符
            .assign(to: \.inputStr, on: vm)
            .store(in: &cancellables)
        
        // inputStr  -> inputTF.text
        vm.$inputStr
            .removeDuplicates() // 避免无限循环
            .assign(to: \.text, on: inputTF)
            .store(in: &cancellables)
        
        // 点击事件 1
        btn.publisher(for: \.isTouchInside)
            .sink { _ in
                // 点击了
            }
            .store(in: &cancellables)
        
        // 点击事件 2
        btn.addAction(UIAction{ [weak self] _ in
            self?.vm.btnClicked.send()
        }, for: .touchUpInside)
        
        vm.btnClicked.sink {
            // 点击事件 来了
            // do .....
            
        }.store(in: &cancellables)
    }
}


extension UserVC {
    func test(){
        
        // 按钮 防重复点击
        btn.publisher(for: \.isTouchInside)
//            .debounce(for: .seconds(1), scheduler: RunLoop.main) // 1 秒内 忽略连续点击
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: false)  // 1 秒内 只能点一次
            .sink { _ in
                print("按钮点击")
            }
            .store(in: &cancellables)
        
    }
}
