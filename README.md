PendingActionManager
================
PendingActionManager provides the ability yo use the timer in continious mode. That is, if the app goes to the background manager saves its stop time and after the app returns to foreground runs the countdown again taking into account the background time.


### How to use

1. Initialize PendingActionManager with time interval and desired tick lenght.
Also you can define handlers for every tick and for completion action.
2. Call `pendingActionManager.startWaiting()` to start a countdown
3. To stop the timer: `pendingActionManager.invalidate()`


