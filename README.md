Here's a downloadable Markdown file (MapMetrics_Integration_Guide.md) with the complete integration guide:

markdown
# MapMetrics iOS SDK Integration Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Adding Markers](#adding-markers)  
   - [Basic Implementation](#basic-marker-implementation)
   - [Customization](#customize-marker-appearance)
   - [Selection Handling](#marker-selection-and-info-view)
4. [Heatmap Implementation](#heatmap-implementation)
5. [Cluster Implementation](#cluster-implementation)
6. [Troubleshooting](#troubleshooting)

## Prerequisites
- Xcode 13+
- iOS 15+ deployment target
- Valid MapMetrics API token
- CocoaPods

## Initial Setup
```swift
// Podfile
pod 'MapMetrics'

// ViewController.swift
import MapMetrics

class ViewController: UIViewController {
    var mapView: MLNMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MLNMapView(
            frame: view.bounds,
            styleURL: URL(string: "https://gateway.mapmetrics-atlas.net/styles/?fileName=YOUR_STYLE_ID/portal.json&token=YOUR_TOKEN")
        )
        mapView.delegate = self
        view.addSubview(mapView)
    }
}
Adding Markers

Basic Implementation

swift
@objc func mapTapped(_ sender: UITapGestureRecognizer) {
    let coordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
    let marker = MLNPointAnnotation()
    marker.coordinate = coordinates
    mapView.addAnnotation(marker)
}
Customize Appearance

swift
func mapView(_ mapView: MLNMapView, viewFor annotation: MLNAnnotation) -> MLNAnnotationView? {
    let view = MLNAnnotationView(annotation: annotation, reuseIdentifier: "marker")
    view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    view.backgroundColor = .systemBlue
    return view
}
Heatmap Implementation

swift
let source = MLNShapeSource(
    identifier: "heatmap-data",
    url: URL(string: "https://your-data.geojson")!,
    options: [.clustered: false]
)

let heatmap = MLNHeatmapStyleLayer(identifier: "heatmap", source: source)
heatmap.heatmapWeight = NSExpression(
    forMLNInterpolating: NSExpression(forKeyPath: "intensity"),
    curveType: .exponential,
    parameters: NSExpression(forConstantValue: 1.5),
    stops: NSExpression(forConstantValue: [0: 0, 5: 1])
)
mapView.style?.addLayer(heatmap)
Cluster Implementation

swift
let source = MLNShapeSource(
    identifier: "clusters",
    url: URL(string: "https://your-data.geojson")!,
    options: [
        .clustered: true,
        .clusterRadius: 30
    ]
)

// Cluster circles
let circles = MLNCircleStyleLayer(identifier: "clusters", source: source)
circles.circleColor = .systemTeal
circles.predicate = NSPredicate(format: "cluster == YES")
mapView.style?.addLayer(circles)
Troubleshooting

Issue	Solution
Map not loading	Verify API token and network connection
Markers invisible	Check delegate assignment and main thread
Heatmap blank	Validate data structure and zoom levels
