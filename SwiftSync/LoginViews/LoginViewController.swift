//
//  ViewController.swift
//  SwiftSync
//
//  Created by Chaitya Vohera on 03/02/24.
//

import ProgressHUD
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlets
    
    // labels
    @IBOutlet var emailLabelOutlet: UILabel!
    @IBOutlet var passwordLabelOutlet: UILabel!
    @IBOutlet var repeatPasswordLabel: UILabel!
    @IBOutlet var signUpLabel: UILabel!
    
    // textFields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var repeatPasswordTextField: UITextField!
    
    // Buttons
    @IBOutlet var signUpButtonOutlet: UIButton!
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var resendButtonOutlet: UIButton!
    
    // Views
    @IBOutlet var repeatPasswordLineView: UIView!
    
    // MARK: - Vars
    
    var isLogin = true
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //         Do any additional setup after loading the view.
        
        updateUIFor(login: true)
        setupTextFieldDelegates()
        setupBackgroundTap()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
            //            print("Have Login/Register Data")
        } else {
            ProgressHUD.showFailed("All Fields are required")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            resetPassword()
            // print("Have Forgot Password Data")
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            // print("Have Resend Email Data")
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    // MARK: - Setup
    
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        updatePlaceHolderLabels(textField: textField)
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    // MARK: - Animations
    
    private func updateUIFor(login: Bool) {
        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)
        
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceHolderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = textField.hasText ? "Email" : ""
            
        case passwordTextField:
            passwordLabelOutlet.text = textField.hasText ? "Password" : ""
            
        default:
            repeatPasswordLabel.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    // MARK: - Helpers
    
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            
            if error == nil {
                if isEmailVerified {
                    // print("User has logged in with email", User.currentUser?.email)
                    
                    self.goToApp()
                } else {
                    ProgressHUD.showFailed("Please verify email.")
                    self.resendButtonOutlet.isHidden = false
                }
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func registerUser() {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
            
        } else {
            ProgressHUD.showFailed("The Passwords don't match")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { error in
            
            if error == nil {
                ProgressHUD.showSuccess("Reset link sent to email.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { error in
            
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    
    private func goToApp() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainApp") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        present(mainView, animated: true, completion: nil)
    }
}
