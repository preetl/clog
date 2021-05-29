import UIKit
import Charts

class ScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        setupScrollView()

    }
    
    // Change your scrollView declaration to this if you want it to always bounce.
    let scrollView : UIScrollView = {
        let sView = UIScrollView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        sView.bounces = true
        sView.alwaysBounceVertical = true
        return sView
    }()
    
    override func viewDidLayoutSubviews(){
        scrollView.contentSize.height = 3000 // I would recommend setting `scrollView.contentSize` in `viewDidLayoutSubviews()` instead. If you are not using the container View approach.
    }

    let containerView = UIView() // constant for the containerView.

    func setupScrollView(){

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // Setting up containerView and disabling horizontal scrolling of the scrollView.

        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        // add the chart

        let entry1 = PieChartDataEntry(value: 3.4, label: "first")
        let entry2 = PieChartDataEntry(value: 4.1, label: "second")
        let dataSet = PieChartDataSet(entries: [entry1, entry2 ], label: "Test chart")

        // Make sure your chart is setup correctly here as `chart`
        let chart = PieChartView()
        chart.data = PieChartData(dataSet: dataSet)
        chart.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(chart)
        let chart2 = chart
        containerView.addSubview(chart2)
        let chart3 = chart
        containerView.addSubview(chart3)

        chart.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100).isActive = true
        chart.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant: 400).isActive = true
        chart.heightAnchor.constraint(equalToConstant: 200).isActive = true
        // Constrain next charts top anchor to the bottom anchor of this chart if you want multiple charts on a vertical axis.
        chart2.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 10).isActive = true
        chart2.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        chart2.widthAnchor.constraint(equalToConstant: 400).isActive = true
        chart2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        chart3.topAnchor.constraint(equalTo: chart2.bottomAnchor, constant: 10).isActive = true
        chart3.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        chart3.widthAnchor.constraint(equalToConstant: 400).isActive = true
        chart3.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

}
