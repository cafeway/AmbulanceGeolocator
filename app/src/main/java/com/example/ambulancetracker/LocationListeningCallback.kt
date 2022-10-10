package com.example.ambulancetracker

import android.util.Log
import com.mapbox.android.core.location.LocationEngineCallback
import com.mapbox.android.core.location.LocationEngineResult
import com.mapbox.geojson.Point
import java.lang.Exception
import java.lang.ref.WeakReference

class LocationListeningCallback internal constructor(activity: Dashboard):LocationEngineCallback<LocationEngineResult>{

    var location:LocationEngineResult?=null
    private val activityWeakReference:WeakReference<Dashboard>
    init {
        this.activityWeakReference = WeakReference(activity)
    }
    override fun onSuccess(result: LocationEngineResult?) {
        setlocation(result)
    }

    override fun onFailure(exception: Exception) {
        TODO("Not yet implemented")
    }
    fun setlocation(result: LocationEngineResult?){
        location = result
    }
    fun get ():LocationEngineResult?{
        return location
    }

}