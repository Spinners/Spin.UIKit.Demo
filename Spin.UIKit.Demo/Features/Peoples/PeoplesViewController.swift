//
//  FilmsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Reusable
import RxFlow
import RxSwift
import RxRelay
import Spin_RxSwift
import UIKit

class PeoplesViewController: UIViewController, StoryboardBased, Stepper {

    fileprivate var uiSpin: RxUISpin<PeoplesFeature.State, PeoplesFeature.Event>!
    private let disposeBag = DisposeBag()

    let steps = PublishRelay<Step>()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var failureLabel: UILabel!
    
    private var datasource = [(People, Bool)]()

    @IBAction func previousTapped(_ sender: UIButton) {
        self.uiSpin.emit(.loadPrevious)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.uiSpin.emit(.loadNext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Peoples"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.uiSpin.render(on: self) { $0.interpret(state:) }
        Observable
            .start(spin: self.uiSpin)
            .disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiSpin.emit(.load)
    }
}

extension PeoplesViewController {
    func interpret(state: PeoplesFeature.State) -> Void {

        guard
            self.activityIndicator != nil,
            self.previouxButton != nil,
            self.nextButton != nil,
            self.failureLabel != nil,
            self.tableView != nil else { return }

        switch state {
        case .idle:
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
            self.tableView.isHidden = false
        case .loading:
            self.activityIndicator.startAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 0.5
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = true
        case .loaded(let peoples, _, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 1
            self.datasource = peoples
            self.tableView.reloadData()
            self.previouxButton.isEnabled = (previous != nil)
            self.nextButton.isEnabled = (next != nil)
            self.failureLabel.isHidden = true
        case .failed:
            self.datasource = []
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.previouxButton.isEnabled = false
            self.nextButton.isEnabled = false
            self.failureLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
}

extension PeoplesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.name
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension PeoplesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let people = self.datasource[indexPath.row].0
        self.steps.accept(AppSteps.people(people: people))
    }
}

extension PeoplesViewController {
    static func make(uiSpin: RxUISpin<PeoplesFeature.State, PeoplesFeature.Event>) -> PeoplesViewController {
        let viewController = PeoplesViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}
