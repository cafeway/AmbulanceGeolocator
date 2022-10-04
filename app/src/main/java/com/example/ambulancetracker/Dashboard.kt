package com.example.ambulancetracker

import android.annotation.SuppressLint
import android.app.backup.BackupAgentHelper
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.location.Location
import android.nfc.Tag
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.PerformanceHintManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.content.ContextCompat
import com.google.android.material.internal.NavigationMenu
import com.google.android.material.internal.NavigationMenuPresenter
import com.mapbox.android.core.permissions.PermissionsListener
import com.mapbox.android.core.permissions.PermissionsManager
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.api.directions.v5.models.DirectionsRoute
import com.mapbox.geojson.Feature
import com.mapbox.geojson.GeoJson
import com.mapbox.geojson.Point
import com.mapbox.mapboxsdk.Mapbox
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.location.*
import com.mapbox.mapboxsdk.location.modes.CameraMode
import com.mapbox.mapboxsdk.location.modes.RenderMode
import com.mapbox.mapboxsdk.maps.MapView
import com.mapbox.mapboxsdk.maps.MapboxMap
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.PropertyValue
import com.mapbox.mapboxsdk.style.layers.SymbolLayer
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource

import com.mapbox.navigation.core.MapboxNavigation
import com.mapbox.navigation.ui.OnNavigationReadyCallback
import com.mapbox.navigation.ui.listeners.NavigationListener
import java.lang.ref.WeakReference

import java.util.*

var mapView: MapView? = null


class Dashboard : AppCompatActivity(),OnMapReadyCallback, PermissionsListener,
    MapboxMap.OnMapClickListener, OnNavigationReadyCallback, NavigationListener {


    // Declare variables for use
    private var permissionsManager: PermissionsManager = PermissionsManager(this)
    private lateinit var locationComponent: LocationComponent
    private lateinit var mapboxMap: MapboxMap
    private var currentRoute: DirectionsRoute?= null
    private lateinit var mapBoxNavigation: MapboxNavigation
    private val TAG = "directions activity"




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Mapbox.getInstance(this, getString(R.string.mapbox_access_token))

        setContentView(R.layout.activity_dashboard)
        val actionBar = supportActionBar
        actionBar?.hide()


        mapView = findViewById(R.id.mapView)
        mapView?.onCreate(savedInstanceState)
        mapView?.getMapAsync(this)
    }

    override fun onMapReady(mapboxMap: MapboxMap) {
        this.mapboxMap = mapboxMap
        mapboxMap.setStyle(Style.MAPBOX_STREETS){
            enableLocationComponent(it)
            addDestinationSymbolLayer(it)
            mapboxMap.addOnMapClickListener(this)
        }
    }

    private fun addDestinationSymbolLayer(loadedMapStyle: Style) {
        loadedMapStyle!!.addImage("destination-icon-id", BitmapFactory.decodeResource(this.resources,R.drawable.mapbox_marker_icon_default))

        val geoJsonSource = GeoJsonSource("destination-source-id")
        loadedMapStyle.addSource(geoJsonSource)

        val destinationSymboLayer = SymbolLayer("destination-symbol-layer-id","destination-source-id")
        destinationSymboLayer.withProperties(PropertyFactory.iconImage("destination-icon-id"),PropertyFactory.iconAllowOverlap(true),PropertyFactory.iconIgnorePlacement(true))

        loadedMapStyle.addLayer(destinationSymboLayer)
    }

    // this function handles clicks from maps
    override fun onMapClick(point: LatLng): Boolean {
        val destinationPoint = Point.fromLngLat(point.longitude,point.latitude)
        val originalPoint = Point.fromLngLat(this.mapboxMap.locationComponent!!.lastKnownLocation!!.longitude,this.mapboxMap.locationComponent!!.lastKnownLocation!!.latitude)
        val source = mapboxMap!!.style!!.getSourceAs<GeoJsonSource>("destination-source-id")

        source?.setGeoJson(Feature.fromGeometry(destinationPoint))

        getRoute(originalPoint,destinationPoint)
        return true
    }

    private fun getRoute(origin: Point?, destination: Point?) {

    }


    // This function get the users current location
    @SuppressLint("MissingPermission")
    private fun enableLocationComponent(loadedMapStyle: Style) {
        // check if the location permission is granted or not
        if (PermissionsManager.areLocationPermissionsGranted(this)){
            // create and customize the LocationComponent's option
            val customLocationComponentOptions = LocationComponentOptions.builder(this)
                .trackingGesturesManagement(true)
                .accuracyColor(ContextCompat.getColor(this,R.color.mapbox_blue))
                .build()


            val locationComponentActivationOptions = LocationComponentActivationOptions.builder(this,loadedMapStyle)
                .locationComponentOptions(customLocationComponentOptions)
                .build()


            // get and instance of the locaation component and  then adjust its settings
            this.mapboxMap.locationComponent.apply{
                //activate the location component with options
                activateLocationComponent(locationComponentActivationOptions)

                // enable to show the location component
                isLocationComponentEnabled = true

                // set the camera mode
                cameraMode = CameraMode.TRACKING


                // choose and set a render mode
                renderMode = RenderMode.COMPASS
            }
        } else {
            permissionsManager = PermissionsManager(this)
            permissionsManager.requestLocationPermissions(this)
        }
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        permissionsManager.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onExplanationNeeded(permissionsToExplain: List<String>) {
        Toast.makeText(this,"fhsadhfkjdshfkjhdskj", Toast.LENGTH_LONG).show()
    }

    override fun onPermissionResult(granted: Boolean)
    {if (granted) {
        enableLocationComponent(mapboxMap.style!!)
    } else {
        Toast.makeText(this,"permission denied", Toast.LENGTH_LONG).show()
        finish()
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

    override fun onNavigationReady(isRunning: Boolean) {
        TODO("Not yet implemented")
    }

    override fun onCancelNavigation() {
        TODO("Not yet implemented")
    }

    override fun onNavigationFinished() {
        TODO("Not yet implemented")
    }

    override fun onNavigationRunning() {
        TODO("Not yet implemented")
    }


}
