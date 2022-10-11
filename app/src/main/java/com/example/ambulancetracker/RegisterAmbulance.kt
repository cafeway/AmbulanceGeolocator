package com.example.ambulancetracker

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle

class RegisterAmbulance : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_register_ambulance)
        val actionBar = supportActionBar
        actionBar?.hide()

    }
}