//
//  ViewController05_NavigationBarDisable.swift
//  NXNavigationExtensionDemo
//
//  Created by lidan on 2021/11/8.
//

import UIKit

class ViewController05_NavigationBarDisable: CustomTableViewController {
    
    private lazy var tableHeaderView =  UIView(frame: .zero)
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Tap1", "Tap2"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(changeSegmentedControl(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    @objc
    private func changeSegmentedControl(_ segmentedControl: UISegmentedControl) {
        print("Value changed: \(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "")")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nil
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        tableHeaderView.addSubview(segmentedControl)
        
        segmentedControl.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -4).isActive = true
        
        leftConstraint = segmentedControl.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor)
        leftConstraint?.isActive = true
        
        rightConstraint = segmentedControl.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor)
        rightConstraint?.priority = .defaultHigh
        rightConstraint?.isActive = true
        
        heightConstraint = segmentedControl.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let navigationBarFrame = navigationController?.navigationBar.frame else { return }
        let tableHeaderViewX = navigationBarFrame.minX
        let tableHeaderViewY = navigationBarFrame.minY
        let tableHeaderViewWidth = navigationBarFrame.width
        let tableHeaderViewHeight = navigationBarFrame.maxY
        
        tableHeaderView.frame = CGRect(x: tableHeaderViewX, y: tableHeaderViewY, width: tableHeaderViewWidth, height: tableHeaderViewHeight)
        tableView.tableHeaderView = tableHeaderView
        
        var safeAreaInsets = navigationController?.navigationBar.layoutMargins
        if #available(iOS 11.0, *) {
            safeAreaInsets = navigationController?.navigationBar.safeAreaInsets
        }
        
        guard let safeAreaInsets = safeAreaInsets else { return }
        heightConstraint?.constant = navigationBarFrame.height * 0.8
        leftConstraint?.constant = safeAreaInsets.left
        rightConstraint?.constant = -safeAreaInsets.right
    }
    
}

extension ViewController05_NavigationBarDisable {
    
    override var nx_translucentNavigationBar: Bool {
        return true
    }
    
    override var nx_enableFullScreenInteractivePopGesture: Bool {
        return true
    }
    
}
