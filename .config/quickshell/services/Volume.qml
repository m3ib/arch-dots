// Handles volume

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick

import qs.components
import qs.services

pragma Singleton

Singleton {
  id: root

  PwObjectTracker {
    objects: [
      Pipewire.defaultAudioSink
    ]
  }

  signal newData()

  property var defaulSink: Pipewire.defaultAudioSink
  property real volume: Pipewire.defaultAudioSink.audio.volume

  function setVolume(value) {
    root.volume = Math.max(0, Math.min(value, 1.5))
    root.newData()
  }

  GlobalShortcut {
    appid: "volume"
    name: "increment"
    description: "Increment default sink's volume"
    onPressed: {
      setVolume(volume+0.05)
    }
  }

  GlobalShortcut {
    appid: "volume"
    name: "decrement"
    description: "Decrement default sink's volume"
    onPressed: {
      setVolume(volume-0.05)
    }
  }
}
