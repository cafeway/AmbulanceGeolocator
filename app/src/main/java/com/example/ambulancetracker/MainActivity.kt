package com.example.ambulancetracker
import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity()  {




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val button:Button = findViewById(R.id.Request)
        button.setOnClickListener{
            val intent = Intent(this,Dashboard::class.java)
            startActivity(intent)
        }
    }

}