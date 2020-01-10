//
//  PlanetsViewController.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import Combine
import ReactiveSwift
import Reusable
import RxFlow
import RxRelay
import Spin_ReactiveSwift
import UIKit

class PlanetsViewController: UIViewController, StoryboardBased, Stepper {

    fileprivate var viewContext: ReactiveViewContext<PlanetsFeature.State, PlanetsFeature.Action>!

    let steps = PublishRelay<Step>()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var previouxButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var failureLabel: UILabel!

    let disposeBag = CompositeDisposable()

    private var datasource = [(Planet, Bool)]()

    @IBAction func previousTapped(_ sender: UIButton) {
        self.viewContext.perform(.loadPrevious)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        self.viewContext.perform(.loadNext)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.viewContext.render(on: self) { $0.interpret(state:) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewContext.perform(.load)
    }


}

extension PlanetsViewController {
    func interpret(state: PlanetsFeature.State) -> Void {

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
        case .loaded(let planets, let previous, let next):
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.alpha = 1
            self.datasource = planets
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

extension PlanetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetCell", for: indexPath)
        cell.textLabel?.text = self.datasource[indexPath.row].0.name
        cell.imageView?.image = self.datasource[indexPath.row].1 ? UIImage(systemName: "star.fill") : nil
        return cell
    }
}

extension PlanetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let planet = self.datasource[indexPath.row].0
        self.steps.accept(AppSteps.planet(planet: planet))
    }
}

extension PlanetsViewController {
    static func make(context: ReactiveViewContext<PlanetsFeature.State, PlanetsFeature.Action>) -> PlanetsViewController {
        let viewController = PlanetsViewController.instantiate()
        viewController.viewContext = context
        return viewController
    }
}


