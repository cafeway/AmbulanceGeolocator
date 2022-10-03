package com.example.ambulancetracker

import android.app.backup.BackupAgentHelper
import android.location.Location
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.PerformanceHintManager
import android.widget.Toast
import androidx.appcompat.content.res.AppCompatResources
import com.mapbox.android.core.permissions.PermissionsListener
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.mapboxsdk.Mapbox
import com.mapbox.mapboxsdk.location.OnCameraTrackingChangedListener
import com.mapbox.mapboxsdk.location.OnLocationClickListener
import com.mapbox.mapboxsdk.maps.MapView
import com.mapbox.mapboxsdk.maps.MapboxMap
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback
import com.mapbox.mapboxsdk.maps.Style
import java.lang.ref.WeakReference

var mapView: MapView? = null


class Dashboard : AppCompatActivity(),OnMapReadyCallback,PermissionsListener,OnLocationClickListener,OnCameraTrackingChangedListener {



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Mapbox.getInstance(this, getString(R.string.mapbox_access_token))

        setContentView(R.layout.activity_dashboard)
        val actionBar = supportActionBar
        actionBar?.hide()


        mapView = findViewById(R.id.mapView)
        mapView?.onCreate(savedInstanceState)
        mapView?.getMapAsync { mapboxMap ->

            mapboxMap.setStyle(Style.MAPBOX_STREETS) {

// Map is set up and the style has loaded. Now you can add data or make other map adjustments


            }

        }

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
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        mapView?.onSaveInstanceState(outState)
    }

    override fun onMapReady(mapboxMap: MapboxMap) {
        TODO("Not yet implemented")
    }

    override fun onExplanationNeeded(p0: MutableList<String>?) {
        TODO("Not yet implemented")
    }

    override fun onPermissionResult(p0: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onLocationComponentClick() {
        TODO("Not yet implemented")
    }

    override fun onCameraTrackingDismissed() {
        TODO("Not yet implemented")
    }

    override fun onCameraTrackingChanged(currentMode: Int) {
        TODO("Not yet implemented")
    }
}