package com.example.ambulancetracker

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.PerformanceHintManager
import com.mapbox.maps.MapView
import com.mapbox.maps.Style
import com.mapbox.maps.plugin.locationcomponent.LocationComponentPlugin2
import com.mapbox.maps.plugin.locationcomponent.LocationProvider

var mapView: MapView? = null


class Dashboard : AppCompatActivity() {

    // create an instance of the locationComponent
    private var permissionManager:PerformanceHintManager? = null
    private var locationProvider: LocationProvider ? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)
        mapView = findViewById(R.id.mapView)
        mapView?.getMapboxMap()?.loadStyleUri(Style.MAPBOX_STREETS)
        val actionBar = supportActionBar
        actionBar?.hide()
    }
    override fun onStart() {
        super.onStart()
        mapView?.onStart()
    }

    override fun onStop() {
        super.onStop()
        mapView?.onStop()
    }

    override fun onLowMemory() {
        super.onLowMemory()
        mapView?.onLowMemory()
    }

    override fun onDestroy() {
        super.onDestroy()
        mapView?.onDestroy()
    }
}