#define TGMS_Callback
/*

*/

#define TweenAddCallback
/// TweenAddCallback(tween,event,target,script[,arg0,arg1,...])
/*
    @tween   = tween id
    @event   = tween event constant -- TWEEN_EV_****
    @target  = instance environment to use when calling script
    @script  = script to be executed
    @arg0... = (optional) arguments to pass to script
    
    RETURN:
        callback id
        
    INFO:
        Sets a script to be called on specified tween event.
        Multiple callbacks can be added to the same event.
        Up to 12 arguments can be passed to the callback script.
        
        "event" can take any of the following TWEEN_EV_**** constants:
        TWEEN_EV_PLAY
        TWEEN_EV_FINISH
        TWEEN_EV_CONTINUE
        TWEEN_EV_STOP
        TWEEN_EV_PAUSE
        TWEEN_EV_RESUME
        TWEEN_EV_REVERSE    
*/

var _tID = argument[0];
var _t = TGMS_FetchTween(_tID);
if (is_undefined(_t)) { return undefined; }

var _events = _t[TWEEN.EVENTS];
var _cb;

// Create and assign events map if it doesn't exist
if (_events == -1)
{
    _events = ds_map_create();
    _t[@ TWEEN.EVENTS] = _events;
}

var _index = argument_count;
repeat(_index-4)
{
    --_index;
    _cb[_index] = argument[_index];
}

// Set default state as active
_cb[TWEEN_CALLBACK.ENABLED] = true;
// Assign target to callback
_cb[TWEEN_CALLBACK.TARGET] = argument[2];
// Assign script to callback
_cb[TWEEN_CALLBACK.SCRIPT] = argument[3]; 
// Assign tween id to callback
_cb[TWEEN_CALLBACK.TWEEN] = _tID;

// IF event type exists...
if (ds_map_exists(_events, argument[1]))
{
    // Cache event
    var _event = _events[? argument[1]];
    // Add event to events map
    ds_list_add(_event, _cb);
    
    // Do some event callback cleanup if size starts to get larger than expected
    if (ds_list_size(_event) mod 10 == 0)
    {   
        ds_priority_add(SharedTweener().eventCleaner, _event, _event);
    }
}
else
{
    // Create event list
    var _event = ds_list_create();
    // Add STATE and CALLBACK to event
    ds_list_add(_event, true, _cb);
    // Add event to events map
    _events[? argument[1]] = _event;
}

// Return callback array
return _cb;



#define TweenAddCallbackUser
/// TweenAddCallbackUser(tween,event,target,user_event)
/*
    @tween       = tween id
    @event       = tween event constant -- TWEEN_EV_****
    @target      = instance environment to use when calling user event
    @user_event  = user event to be called when callback executed (0-15)
    
    RETURN:
        callback id
        
    INFO:
        Sets a user event (0-15) to be called on specified tween event.
        Multiple callbacks can be added to the same event.
        
        "event" can take any of the following TWEEN_EV_**** constants:
        TWEEN_EV_PLAY
        TWEEN_EV_FINISH
        TWEEN_EV_CONTINUE
        TWEEN_EV_STOP
        TWEEN_EV_PAUSE
        TWEEN_EV_RESUME
        TWEEN_EV_REVERSE    
*/

TweenAddCallback(argument0, argument1, argument2, TGMS_EventUser, argument3);

#define TweenCallbackNull
/// TweenCallbackNull()

return undefined;

#define TweenCallbackIsValid
/// TweenCallbackIsValid(callback)
/*
    @callback = callback id
    
    RETURN:
        bool
        
    INFO:
        Returns whether or not the callback is valid (exists)
        
    Example:
        if (TweenCallbackValid(callback))
        {
            TweenCallbackInvalidate(callback);
        }
*/

var _cb = argument0;

if (is_array(_cb))
{
    return TweenExists(_cb[TWEEN_CALLBACK.TWEEN]);
}

return false;


#define TweenCallbackInvalidate
/// TweenCallbackInvalidate(callback)
/*
    @callback = callback id
    
    RETURN:
        na
        
    INFO:
        Removes the callback from it's relevant tween event
        
    Example:
        // Create tween and add callback to finish event
        tween = TweenCreate(id);
        cb = TweenEventAddCallback(tween, TWEEN_EV_FINISH, id, ShowMessage, "Finished!");
        
        // Invalidate callback -- effectively removes it from tween event
        TweenInvalidate(cb);
*/

var _cb = argument0;

if (is_array(_cb))
{
    // Set target as noone -- used for system cleaning
    _cb[@ TWEEN_CALLBACK.TARGET] = noone;
    _cb[@ TWEEN_CALLBACK.TWEEN] = TweenNull();
}

#define TweenCallbackEnable
/// TweenCallbackEnable(callback,enable)
/*
    @callback = callback id
    @enable   = enable callback execution?
    
    RETURN:
        na
        
    INFO:
        Allows specified callbacks to be enabled/disabled
*/

var _cb = argument0;

if (is_array(_cb))
    _cb[@ TWEEN_CALLBACK.ENABLED] = argument1;



#define TweenCallbackIsEnabled
/// TweenCallbackIsEnabled(callback)
/*
    @callback = callback id
    
    RETURN:
        bool
        
    INFO:
        Returns whether or not a specified callback is enabled
*/

var _cb = argument0;

if (is_array(_cb))
    return _cb[TWEEN_CALLBACK.ENABLED];