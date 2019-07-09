//
//  ViewController.swift
//  Project31
//
//  Created by Miloslav Milenkov on 09/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    @IBOutlet var addressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [add,delete]
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    @objc func addWebView() {
        let webview = WKWebView()
        webview.navigationDelegate = self
        webview.layer.backgroundColor = UIColor.blue.cgColor
        selectWebView(webview)
        
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recogniser.delegate = self
        webview.addGestureRecognizer(recogniser)
        
        stackView.addArrangedSubview(webview)
        let url = URL(string: "https://www.hackingwithswift.com")!
        webview.load(URLRequest(url:url))
    }
    
    @objc func deleteWebView() {
        guard let webView = activeWebView else { return }
        guard let index = stackView.arrangedSubviews.firstIndex(of: webView) else { return }
        
        stackView.removeArrangedSubview(webView)
        webView.removeFromSuperview()
        
        if stackView.arrangedSubviews.count == 0 {
            setDefaultTitle()
        } else {
            var currentIndex = Int(index)
            
            if currentIndex == stackView.arrangedSubviews.count {
                currentIndex = stackView.arrangedSubviews.count - 1
            }
            
            if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                selectWebView(newSelectedWebView)
            }
        }
    }
    
    @objc func webViewTapped(_ recogniser: UITapGestureRecognizer) {
        if let selectedWebView = recogniser.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        activeWebView = webView
        webView.layer.borderWidth = 3
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }
        textField.resignFirstResponder()
        return true
    }

}

