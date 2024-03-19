import UIKit
import RealmSwift

class ViewController: UIViewController {
    private let idTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter an id"
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a password"
        
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let getButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GET", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "result"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = .white
        
        [
            idTextField,
            passwordTextField,
            addButton,
            getButton,
            resultLabel
        ].forEach {
            self.view.addSubview($0)
        }
        
        setupConstraints()
        setupBindings()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            idTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            idTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: self.idTextField.bottomAnchor, constant: 20),
            passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 20),
            addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            getButton.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 20),
            getButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            getButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            getButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: self.getButton.bottomAnchor, constant: 20),
            resultLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            resultLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
        ])
    }
    
    private func setupBindings() {
        addButton.addTarget(self, action: #selector(addToRealm), for: .touchUpInside)
        getButton.addTarget(self, action: #selector(getFromRealm), for: .touchUpInside)
    }
}

// MARK: - Realm
extension ViewController {
    @objc func addToRealm() {
        guard let idText = self.idTextField.text,
              let passwordText = self.passwordTextField.text 
        else {
            return
        }
        
        let realm = try! Realm()
        
        let user = User()
        user._id = idText
        user.password = passwordText
        
        do {
            try realm.write {
                realm.add(user, update: .modified)
            }
        } catch {
            print("저장 및 업데이트 실패 : \(error.localizedDescription)")
        }
        
        self.resultLabel.text = "저장 완료\n\(user.description)"
    }
    
    @objc func getFromRealm(){
        guard let idText = self.idTextField.text else {
            return
        }
        
        let realm = try! Realm()
        
        let savedUsers = realm.objects(User.self)
        
        // test로 아이디를 등록 했다면 필터링해서 조회됨
        let user = savedUsers.filter("_id == %@", "test")
        
        self.resultLabel.text = "조회 완료\n\(user.description)"
    }
}

