package com.example.radio_taqriibussunnah

import android.content.Intent
import android.os.Process
import com.ryanheise.audioservice.AudioService

class RecentTaskAwareAudioService : AudioService() {
    @Suppress("DEPRECATION")
    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        stopForeground(true)
        stopSelf()
        Process.killProcess(Process.myPid())
    }
}
