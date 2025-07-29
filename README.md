# 📍 MapMetrics iOS Integration Guide

This guide explains how to integrate **Heatmaps**, **Clusters**, and **Markers** using the **MapMetrics (MapLibre Native)** SDK in your iOS app.

---

## 🚀 1. Initial Setup

1. **Import the SDK**:

   ```swift
   import MapMetrics
   ```

2. **Create a `MLNMapView` instance**:

   ```swift
   mapView = MLNMapView(frame: view.bounds,
                        styleURL: URL(string: "https://demotiles.maplibre.org/style.json"))
   mapView.delegate = self
   view.addSubview(mapView)
   ```

---

## 🔥 2. Add Heatmap Layer

### ✅ Step-by-Step:

1. **Remove existing heatmap source and layer (if any):**

   ```swift
   if let existingSource = style.source(withIdentifier: "earthquakes") {
       style.removeSource(existingSource)
   }
   if let existingLayer = style.layer(withIdentifier: "earthquakes-heat") {
       style.removeLayer(existingLayer)
   }
   ```

2. **Create the heatmap source:**

   ```swift
   let url = URL(string: "https://maplibre.org/maplibre-gl-js/docs/assets/earthquakes.geojson")!
   let source = try MLNShapeSource(identifier: "earthquakes", url: url, options: [.clustered: false])
   try style.addSource(source)
   ```

3. **Configure the heatmap layer:**

   ```swift
   let heatmap = MLNHeatmapStyleLayer(identifier: "earthquakes-heat", source: source)
   heatmap.heatmapWeight = ... // based on mag
   heatmap.heatmapIntensity = ... // based on zoom
   heatmap.heatmapColor = ... // gradient from blue to red
   heatmap.heatmapRadius = ...
   heatmap.heatmapOpacity = NSExpression(forConstantValue: 0.8)
   heatmap.isVisible = false

   try style.addLayer(heatmap)
   ```

4. **Optional:** Insert layer above water if needed.

---

## 🌐 3. Add Clusters

### ✅ Step-by-Step:

1. **Create a clustered shape source:**

   ```swift
   let source = try MLNShapeSource(
       identifier: "clusteredEarthquakes",
       url: URL(string: "https://maplibre.org/maplibre-gl-js/docs/assets/earthquakes.geojson")!,
       options: [.clustered: true, .clusterRadius: 30]
   )
   try style.addSource(source)
   ```

2. **Add unclustered points layer:**

   ```swift
   let unclustered = MLNCircleStyleLayer(identifier: "earthquake-circles", source: source)
   unclustered.predicate = NSPredicate(format: "cluster != YES")
   unclustered.circleColor = NSExpression(forConstantValue: UIColor.red)
   ...
   try style.addLayer(unclustered)
   ```

3. **Add clusters layer:**

   ```swift
   let clusters = MLNCircleStyleLayer(identifier: "clusters", source: source)
   clusters.predicate = NSPredicate(format: "cluster == YES")
   clusters.circleColor = NSExpression(forConstantValue: UIColor.blue)
   ...
   try style.addLayer(clusters)
   ```

4. **Add cluster labels:**

   ```swift
   let labels = MLNSymbolStyleLayer(identifier: "cluster-labels", source: source)
   labels.text = NSExpression(format: "CAST(point_count, 'NSString')")
   ...
   try style.addLayer(labels)
   ```

---

## 📌 4. Add Custom Markers with Editable Labels

### ✅ Tap to Add:

```swift
@objc func mapTapped(_ sender: UITapGestureRecognizer) {
    guard !isMarkerSelected else { return }
    let location = sender.location(in: mapView)
    let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
    addMarker(at: coordinates)
}

func addMarker(at coordinates: CLLocationCoordinate2D) {
    let marker = MLNPointAnnotation()
    marker.coordinate = coordinates
    marker.title = "Tap to add a name"
    mapView.addAnnotation(marker)
}
```

### ✅ Marker Selection:

```swift
func mapView(_ mapView: MLNMapView, didSelect annotation: MLNAnnotation) {
    if let point = annotation as? MLNPointAnnotation {
        isMarkerSelected = true
        selectedAnnotation = point
        showInfoView(for: point)
    }
}
```

### ✅ Edit Title View:

* Use a bottom sheet or a popup (`UIView`) with `UITextField` to change the marker title.
* Update annotation title on `textFieldShouldReturn`.

---

## 🎮 Toggle Layers (Markers / Clusters / Heatmap)

Use a `UISegmentedControl` to toggle visibility of layers:

```swift
@objc func toggleMapView(_ sender: UISegmentedControl) {
    let heatmapLayer = style.layer(withIdentifier: "earthquakes-heat")
    let clustersLayer = style.layer(withIdentifier: "clusters")
    let clusterLabelsLayer = style.layer(withIdentifier: "cluster-labels")
    let circlesLayer = style.layer(withIdentifier: "earthquake-circles")

    switch sender.selectedSegmentIndex {
    case 0: // Markers
        ...
    case 1: // Clusters
        ...
    case 2: // Heatmap
        ...
    default: break
    }
}
```

---

## ✅ Summary

| Feature  | Layers                       | Source Identifier      |
| -------- | ---------------------------- | ---------------------- |
| Heatmap  | `earthquakes-heat`           | `earthquakes`          |
| Clusters | `clusters`, `cluster-labels` | `clusteredEarthquakes` |
| Markers  | `earthquake-circles`         | `clusteredEarthquakes` |

---

## 🧪 Testing Tips

* Use `debugLayers()` to print active layers.
* Use `verifyDataSource()` to inspect sources and shapes.

---

For questions or improvements, reach out to your SDK maintainer.

Happy Mapping! 🗺️
