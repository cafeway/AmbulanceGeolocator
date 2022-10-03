package com.example.ambulancetracker

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.ActionBar

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val actionBar = supportActionBar
        actionBar?.hide()


        // get button by reference
        val button = findViewById<Button>(R.id.Request)
        // set  a listner
        button.setOnClickListener{
            val intent = Intent(this,Dashboard::class.java)
            startActivity(intent)
        }

    }
}