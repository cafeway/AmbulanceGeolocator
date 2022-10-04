package com.example.ambulancetracker
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.mapbox.api.directions.v5.models.DirectionsRoute
import com.mapbox.mapboxsdk.Mapbox
import com.mapbox.navigation.core.MapboxNavigation
import com.mapbox.navigation.ui.NavigationViewOptions
import com.mapbox.navigation.ui.OnNavigationReadyCallback
import com.mapbox.navigation.ui.listeners.NavigationListener
import com.mapbox.navigation.ui.map.NavigationMapboxMap
class MainActivity : AppCompatActivity() {

    private lateinit var navigationMapboxMap: NavigationMapboxMap
    private lateinit var mapboxNavigation: MapboxNavigation


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}