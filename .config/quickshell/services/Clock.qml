// Time & date tools

import Quickshell
import QtQuick

pragma Singleton

Singleton {
  id: root

  property ListModel timersModel: ListModel {}
  property bool stopwatchRunning: false
  property real stopwatch: 0

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Timer {
    id: timeKeeper

    interval: 10
    running: true
    repeat: true
    onTriggered: {
      if (root.stopwatchRunning) {
        root.stopwatch += timeKeeper.interval;
      }
      for (let i = 0; i < root.timersModel.count; i++) {
        const current = root.timersModel.get(i)
        const newTimeLeft = Math.max(0, current.timeLeft - interval)

        root.timersModel.setProperty(i, "timeLeft", newTimeLeft)

        if (newTimeLeft <= 0) {
          root.timersModel.remove(i)
        }
      }
    }
  }

  /**
   * Format the current time.
   * @param  {String} fmt  The format.
   * @return {String}      Formatted time.
   */
  function fmtTime(fmt) {
    return Qt.formatDateTime(clock.date, fmt);
  }

  /**
   * Format duration into hh:mm:ss.ms
   * @param  {Number} duration  The duration in milliseconds.
   * @return {String}           Formatted duration.
   */
  function fmtDuration(duration) {
    const hours = Math.floor(duration / 3_600_000);
    const mins = Math.floor((duration % 3_600_000) / 60_000);
    const secs = Math.floor((duration % 60_000) / 1000);
    const msecs = duration % 1000;

    const hs = hours.toString().padStart(2, "0")
    const ms = mins.toString().padStart(2, "0")
    const ss = secs.toString().padStart(2, "0")
    const msc = msecs.toString().padStart(2, "0").substring(0, 2)

    return `${hs}:${ms}:${ss}.${msc}`
  }

  /** Parse a string duration into milliseconds.
   * @param {String} str A duration string (2h 30m 20s 15i).
   * @return {Number} in milliseconds.
   */
  function parseDuration(str) {
    let msecs = 0;
    const fields = str.split(" ");

    fields.forEach((field) => {
      const val = Number(field.substring(0, field.length - 1))

      switch (field[field.length - 1].toLowerCase()) {
        case "h":
          msecs += val * 3_600_000;
          break;
        case "m":
          msecs += val * 60_000;
          break;
        case "s":
          msecs += val * 1000;
          break;
        case "i":
          msecs += val;
          break;
        default:
          break;
      }
    })

    return msecs
  }

  /** Produce an appropriate ordinal suffix for the given number.
   * @param {Number} n The number.
   * @return {String} The ordinal suffix.
   */
  function ordinalSuffix(n) {
    if (n > 4 && n < 20) {
      return "th"
    }

    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
        break;
      case 3:
        return 'rd';
        break;
      default:
        return 'th'

    }
  }

  /** Create a new timer.
   * @param {String} timerTitle The title of the timer.
   * @param {Number} duration The duration of the timer in milliseconds.
   * @return {Number} The id of the timer.
   */
  function createTimer(timerTitle, duration) {
    root.timersModel.append({
      title: timerTitle || "Unnamed",
      initialDuration: duration,
      timeLeft: duration
    });

    return root.timersModel.count - 1;
  }

  function startStopwatch() {
    root.stopwatchRunning = true;
  }

  function pauseStopwatch() {
    root.stopwatchRunning = false;
  }

  function resetStopwatch() {
    root.stopwatchRunning = false;
    root.stopwatch = 0;
  }
}
