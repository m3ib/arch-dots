// Time & date tools
pragma Singleton

import Quickshell
import QtQuick

import qs.services

Singleton {
  id: root

  property ListModel timersModel: ListModel {}
  property bool stopwatchRunning: false
  property real stopwatch: 0

  property bool focusing: false
  // statistics
  property int pomoSessions: 0
  property real pomoTime: 0 // milliseconds

  property var pomoDurations: Object.freeze({
    FOCUS: Config.pomo.focus,
    SHORT_BREAK: Config.pomo.shortBreak,
    LONG_BREAK: Config.pomo.longBreak
  })
  property var pomo: QtObject {
    property string mode: Object.keys(pomoDurations)[0]
    property int initialDuration: Object.values(pomoDurations)[0]
    property int timeLeft: Object.values(pomoDurations)[0]
    property bool paused: false
  }

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

      if (root.focusing && !root.pomo.paused) {
        const newPomoTime = Math.max(0, root.pomo.timeLeft - timeKeeper.interval);
        root.pomo.timeLeft = newPomoTime;

        if (newPomoTime === 0) {
          OsdService.showOsd(`Pomodoro ${getPomoLowerCase()} ended.`)
          nextPomoMode()
        }
      }

      for (let i = 0; i < root.timersModel.count; i++) {
        const current = root.timersModel.get(i);
        if (!current.running) continue;
        const newTimeLeft = current.timeLeft - interval;

        if (newTimeLeft < 0) {
          OsdService.showOsd(`Timer "${current.title}" ended.`);
          ShellState.leftBar.show = true; // force-show the leftBar
        }

        root.timersModel.setProperty(i, "timeLeft", newTimeLeft);
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

  /** Extract hours, minutes, seconds, and milliseconds from a duration (in ms).
   * @param {Number} duration The duration in milliseconds.
   * @return {Object} Object with keys [hours, minutes, seconds, ms].
   */
  function extractTimeUnits(duration) {
    const d = Math.abs(duration);
    const hours = Math.floor(d / 3_600_000);
    const mins = Math.floor((d % 3_600_000) / 60_000);
    const secs = Math.floor((d % 60_000) / 1000);
    const msecs = d % 1000;

    return {hours: hours, minutes: mins, seconds: secs, ms: msecs}
  }

  /**
   * Format duration into hh:mm:ss.ms
   * @param  {Number} duration  The duration in milliseconds.
   * @return {String}           Formatted duration.
   */
  function fmtDuration(duration) {
    const timeUnits = extractTimeUnits(duration);

    const h = timeUnits.hours.toString().padStart(2, "0")
    const m = timeUnits.minutes.toString().padStart(2, "0")
    const s = timeUnits.seconds.toString().padStart(2, "0")
    const ms = timeUnits.ms.toString().padStart(2, "0").substring(0, 2)

    return `${h}:${m}:${s}.${ms}`
  }

  /** Format duration into hh'h' mm'm', e.g. 8h 30m.
   * @param {Number} duration The duration in milliseconds.
   * @return {String}         Formatted duration.
   */
  function fmtHumanDuration(duration) {
    const timeUnits = extractTimeUnits(duration);

    const h = timeUnits.hours + "h"
    const m = timeUnits.minutes ? `${timeUnits.minutes}m` : ''

    return `${h} ${m}`
  }

  /** Parse a string duration into milliseconds.
   * @param {String} str A duration string (2h 30m 20s 15ms).
   * @return {Number} in milliseconds.
   */
  function parseDuration(str) {
    let msecs = 0;
    const fields = str.split(" ");

    fields.forEach((field) => {
      const valM = field.match(/^\d+/);
      const unitM = field.match(/[A-Za-z]+$/);

      if (!valM) return;
      const val = Number(valM[0]);
      const unit = !!unitM ? unitM[0] : "";

      let factor = 1;
      switch (unit.toLowerCase()) {
        case "d":
          factor = 86_400_000;
          break;
        case "h":
          factor =  3_600_000;
          break;
        case "m":
          factor = 60_000;
          break;
        case "s":
          factor = 1000;
          break;
        default:
          break;
      }
      msecs += val*factor;
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
    const timerId = root.timersModel.count;
    root.timersModel.append({
      id: timerId,
      title: timerTitle || "Unnamed",
      running: true,
      initialDuration: duration,
      timeLeft: duration
    });

    return timerId;
  }

  /** Set stopwatch running state.
   * @param {Boolean} state
   */
  function setStopwatch(state) {
    root.stopwatchRunning = state;
  }

  /** Toggle stopwatch running state. */
  function toggleStopwatch() {
    root.stopwatchRunning = !root.stopwatchRunning;
  }

  /** Reset stopwatch and pause it. */
  function resetStopwatch() {
    root.stopwatchRunning = false;
    root.stopwatch = 0;
  }

  /** Find the timer index in timersModel that has a certain id.
   * @param {Number} id The id of the timer.
   * @return {Number || Null} The timer's index or Null if it's not found.
   */
  function _getRealTimerId(id) {
    for (let i = 0; i < root.timersModel.count; i++) {
      const current = root.timersModel.get(i);

      if (current.id !== id) continue;

      return i;
    }

    return Null;
  }

  /** Set a timer's running state.
   * @param {Number} id The id of the timer.
   * @param {Boolean} state The state to set the timer to.
   */
  function setTimer(id, state) {
    timersModel.setProperty(_getRealTimerId(id), "running", state);
  }

  /** Toggle a timer's running state.
   * @param {Number} id The id of the timer.
   */
  function toggleTimer(id) {
    const timerIdx = _getRealTimerId(id)
    const timer = timersModel.get(timerIdx);

    timersModel.setProperty(timerIdx, "running", !timer.running);
  }

  /** Reset a timer and pause it.
   * @param {Number} id The id of the timer.
   */
  function resetTimer(id) {
    const timerIdx = _getRealTimerId(id)
    const timer = timersModel.get(timerIdx);

    timersModel.setProperty(timerIdx, "running", false);
    timersModel.setProperty(timerIdx, "timeLeft", timer.initialDuration);
  }

  /** Remove a timer.
   * @param {Number} id The id of the timer.
   */
  function removeTimer(id) {
    timersModel.remove(_getRealTimerId(id));
  }

  /** Return the given pomo mode in a human readable title case.
   * Note: if no mode is given, the current pomo mode is assumed.
   * @return {String} The mode in title case.
   */
  function getPomoTitleCase(m = undefined) {
    const mode = m ?? root.pomo.mode;
    let out = "";
    mode.replace("_", " ").toLowerCase().split(" ").forEach(word => {
      out += word[0].toUpperCase() + word.substring(1, word.length) + " "
    })

    return out.trim();
  }

  /** Return the given pomo mode in a human readable lower case.
   * Note: if no mode is given, the current pomo mode is assumed.
   * @return {String} The mode in lower case.
   */
  function getPomoLowerCase(m = undefined) {
    const mode = m ?? root.pomo.mode;

    return mode.toLowerCase().replace("_", " ").trim();
  }

  /** Update focus time stastics by the current pomo duration. */
  function trackFocusTime() {
    if (pomo.mode !== "FOCUS") return;
    root.pomoTime += pomo.initialDuration - pomo.timeLeft;
  }


  /** Start a new focus session. */
  function startFocusSession() {
    root.focusing = true;
    root.pomo.paused = false;
    root.pomoSessions = 0;
    setPomoMode("FOCUS");
  }

  /** End the current focus session. */
  function endFocusSession() {
    root.focusing = false;
    root.pomo.paused = true
    // partial focus session
    if (root.pomo.mode == "FOCUS") trackFocusTime()
  }

  /** Toggle pomodoro puase state. */
  function togglePomoPause() {
    root.pomo.paused = !root.pomo.paused;
  }

  /** Set pomodoro mode.
   * Note: simply sets the active mode and timer.
   * @param {String} m The mode.
   * @param {Number} duration A custom duration (milliseconds), if not specified uses the default value for the given mode.
   */
  function setPomoMode(m, duration = undefined) {
    if (!m in Object.keys(root.pomoDurations)) {
      console.error(`SetPomoMode: invalid mode '${m}'.`);
      return;
    }

    const pomoTime = duration ?? root.pomoDurations[m];

    root.pomo.mode = m;
    root.pomo.initialDuration = pomoTime;
    root.pomo.timeLeft = pomoTime;
  }


  /** Get the next pomo mode after the current one.
   * @return {String} The next pomo mode.
   */
  function getNextPomo() {
    if (root.pomo.mode !== "FOCUS") {
      return "FOCUS";
    }

    const nextSessionsCount = root.pomoSessions + 1;
    if (nextSessionsCount % Config.pomo.sessionsBeforeLongBreak === 0) {
      return "LONG_BREAK"
    }

    return "SHORT_BREAK";
  }

  /** Go to the next pomodoro mode. */
  function nextPomoMode() {
    const m = getNextPomo();

    if (m === "FOCUS") {
      root.pomoSessions++;
      root.pomo.paused = true; // don't auto-start focus
    } else {
      root.pomo.paused = false; // auto-start breaks
    }

    trackFocusTime();
    setPomoMode(m);
  }

  /** Reset the pomodoro timer to the initial value. */
  function resetPomoTimer() {
    root.pomo.timeLeft = root.pomo.initialDuration;
  }

  /** Change pomodoro mode timer by delta amount.
   * @param {Number} delta Number of milliseconds.
   */
  function updatePomoTimer(delta) {
    root.pomo.timeLeft = Math.max(0, root.pomoTimer + delta);
  }
}
