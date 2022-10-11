package com.example.ambulancetracker


import android.Manifest
import android.annotation.SuppressLint
import android.app.PendingIntent
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.annotation.DrawableRes
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.content.res.AppCompatResources
import androidx.core.app.ActivityCompat
import com.google.gson.GsonBuilder
import com.mapbox.android.core.location.*
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.api.directions.v5.models.DirectionsRoute
import com.mapbox.api.directions.v5.models.RouteOptions
import com.mapbox.common.location.Location
import com.mapbox.geojson.Point
import com.mapbox.maps.*
import com.mapbox.maps.extension.observable.eventdata.MapLoadedEventData
import com.mapbox.maps.extension.style.expressions.dsl.generated.interpolate
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.annotation.AnnotationManagerImpl
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.createPointAnnotationManager
import com.mapbox.maps.plugin.delegates.listeners.OnMapLoadedListener
import com.mapbox.maps.plugin.gestures.GesturesPlugin
import com.mapbox.maps.plugin.gestures.OnMapClickListener
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import com.mapbox.maps.plugin.locationcomponent.*
import com.mapbox.navigation.base.extensions.applyDefaultNavigationOptions
import com.mapbox.navigation.base.route.*
import com.mapbox.navigation.core.MapboxNavigation
import java.lang.ref.WeakReference
import java.lang.Exception

/**
 * Tracks the user location on screen, simulates a navigation session.
 */
class Dashboard: AppCompatActivity(),OnMapLoadedListener,LocationEngineCallback<LocationEngineResult> {
    private  val mapBoxNavigation: MapboxNavigation? = null
    private val callback = LocationListeningCallback(this)
    private val onIndicatorBearingChangedListener = OnIndicatorBearingChangedListener {
        mapView.getMapboxMap().setCamera(CameraOptions.Builder().bearing(it).build())
    }

    private val onIndicatorPositionChangedListener = OnIndicatorPositionChangedListener {
        mapView.getMapboxMap().setCamera(CameraOptions.Builder().center(it).build())
        mapView.gestures.focalPoint = mapView.getMapboxMap().pixelForCoordinate(it)
    }
    private val onMoveListener = object : OnMoveListener {
        override fun onMoveBegin(detector: MoveGestureDetector) {
            onCameraTrackingDismissed()
        }

        override fun onMove(detector: MoveGestureDetector): Boolean {
            return false
        }

        override fun onMoveEnd(detector: MoveGestureDetector) {}
    }
    private lateinit var mapView: MapView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val actionBar = supportActionBar
        actionBar?.hide()
        setContentView(R.layout.activity_dashboard)
        mapView = findViewById(R.id.mapView)
        onMapReady()
    }

    private fun onMapReady() {
        mapView.getMapboxMap().setCamera(
            CameraOptions.Builder()
                .zoom(14.0)
                .build()
        )
        mapView.getMapboxMap().loadStyleUri(
            Style.MAPBOX_STREETS
        ) {
            initLocationComponent()
            setupGesturesListener()
        }
    }

    private fun setupGesturesListener() {
        mapView.gestures.addOnMoveListener(onMoveListener)
        mapView.gestures.addOnMapClickListener(onMapClickListener)
    }

    private fun initLocationComponent() {
        val locationComponentPlugin = mapView.location
        locationComponentPlugin.updateSettings {
            this.enabled = true
            this.locationPuck = LocationPuck2D(
                bearingImage = AppCompatResources.getDrawable(
                    this@Dashboard,
                    R.drawable.mapbox_user_puck_icon,
                ),
                shadowImage = AppCompatResources.getDrawable(
                    this@Dashboard,
                    R.drawable.mapbox_user_icon_shadow,
                ),
                scaleExpression = interpolate {
                    linear()
                    zoom()
                    stop {
                        literal(0.0)
                        literal(0.6)
                    }
                    stop {
                        literal(20.0)
                        literal(1.0)
                    }
                }.toJson()
            )
        }
        locationComponentPlugin.addOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        locationComponentPlugin.addOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
    }
    //This function add annotations or a marker to the map
    @SuppressLint("ResourceType")
    private fun AddMarkerAnnotaton (point: Point,origin: Point){
        // Create an instance of the Annotation API and get the PointAnnotationManager.
        bitmapFromDrawableRes(
            this@Dashboard,
            R.drawable.red_marker
        )?.let {
            val annotationApi = mapView?.annotations
            val pointAnnotationManager = annotationApi?.createPointAnnotationManager(mapView!!)
            // Set options for the resulting symbol layer.
            val pointAnnotationOptions: PointAnnotationOptions = PointAnnotationOptions()
                // Define a geographic coordinate.
                .withPoint(point)
                // Specify the bitmap you assigned to the point annotation
                // The bitmap will be added to map style automatically.
                .withIconImage(it)
            // Add the resulting pointAnnotation to the map.
            pointAnnotationManager?.create(pointAnnotationOptions)
        }

        getRoute(origin,point)

    }
    private fun bitmapFromDrawableRes(context: Context, @DrawableRes resourceId: Int) =
        convertDrawableToBitmap(AppCompatResources.getDrawable(context, resourceId))

    private fun convertDrawableToBitmap(sourceDrawable: Drawable?): Bitmap? {
        if (sourceDrawable == null) {
            return null
        }
        return if (sourceDrawable is BitmapDrawable) {
            sourceDrawable.bitmap
        } else {
            // copying drawable object to not manipulate on the same reference
            val constantState = sourceDrawable.constantState ?: return null
            val drawable = constantState.newDrawable().mutate()
            val bitmap: Bitmap = Bitmap.createBitmap(
                drawable.intrinsicWidth, drawable.intrinsicHeight,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }
    }
    private fun onCameraTrackingDismissed() {
        Toast.makeText(this, "onCameraTrackingDismissed", Toast.LENGTH_SHORT).show()
        mapView.location
            .removeOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        mapView.location
            .removeOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
        mapView.gestures.removeOnMoveListener(onMoveListener)
    }
    // This function generates a route between the current users location to a marked area on the map
    private fun getRoute(origin:Point,destination:Point){

        val originLocation = Point.fromLngLat(-122.4192,-122.4192)
        val destinationPoint = Point.fromLngLat(-122.4106, 37.7676)
        val routeOptions = RouteOptions.builder().applyDefaultNavigationOptions()
            .coordinatesList(listOf(originLocation,destinationPoint))
            .build()
       mapBoxNavigation?.requestRoutes(routeOptions= routeOptions,navigationCallback)
    }

    // Navigations Route Callback
    private val navigationCallback = object:NavigationRouterCallback{
        override fun onCanceled(routeOptions: RouteOptions, routerOrigin: RouterOrigin) {
            TODO("Not yet implemented")
        }

        override fun onFailure(reasons: List<RouterFailure>, routeOptions: RouteOptions) {
            TODO("Not yet implemented")
        }

        override fun onRoutesReady(routes: List<NavigationRoute>, routerOrigin: RouterOrigin) {
            TODO("Not yet implemented")
        }

    }

    override fun onDestroy() {
        super.onDestroy()
        mapView.location
            .removeOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
        mapView.location
            .removeOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        mapView.gestures.removeOnMoveListener(onMoveListener)
        mapView.gestures.removeOnMapClickListener(onMapClickListener)
    }
    @SuppressLint("MissingPermission")
    private val onMapClickListener = object: OnMapClickListener {

        override fun onMapClick(destination: Point): Boolean {
            var locationEngine= LocationEngineProvider.getBestLocationEngine(applicationContext)
            val time_in_seconds = 1000L
            val max_wait_time = time_in_seconds * 5
            val request = LocationEngineRequest.Builder(time_in_seconds)
                .setPriority(LocationEngineRequest.PRIORITY_NO_POWER)
                .setMaxWaitTime(max_wait_time)
                .build()

            locationEngine.requestLocationUpdates(request,callback,mainLooper)
            locationEngine.getLastLocation(callback)

            // Getting results from the callback
            if (callback.get() != null)
            {
                var latitude: Double? = callback.get()!!.lastLocation?.latitude
                var longitude: Double? = callback.get()!!.lastLocation?.longitude
                var origin:Point = Point.fromLngLat(longitude!!,latitude!!)
                AddMarkerAnnotaton(destination,origin)

            }


//            // add a destination marker to the map

            return true
        }

    }



    override fun onMapLoaded(eventData: MapLoadedEventData) {
        Log.d("Mapclicked","mapLoaded")
    }

    override fun onSuccess(result: LocationEngineResult?) {
        TODO("Not yet implemented")
    }

    override fun onFailure(exception: Exception) {
        TODO("Not yet implemented")
    }


//    override fun onRequestPermissionsResult(
//        requestCode: Int,
//        permissions: Array<String>,
//        grantResults: IntArray
//    ) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
//        locationPermissionHelper.onRequestPermissionsResult(requestCode, permissions, grantResults)
//    }
}