USING System.Timer;
USING Simatic.Ax.IO.Input;
NAMESPACE Simatic.Ax.Actuators    
    // Class representing an endswitch, implementing the ItfEndswitch interface.
    CLASS BooleanEndswitch IMPLEMENTS itfEndswitch, itfBooleanUpdate, itfErrorProvider
        VAR PUBLIC
            Behavior : EndswitchBehavior; // Defines whether the endswitch is normally open or closed.
            SuperVisionTimeAction : LTIME := T#5s;
            SuperVisionTimeReaction : LTIME := T#1s;
        END_VAR
        
        VAR
            _binSignal : BinSignal; // Binary signal for the endswitch.
            _monTimer : Ondelay;    // Timer for monitoring the endswitch.
            _errorState : SuperVisionError;
            _superVisionMode : SuperVisionMode;
            
            _errorReceiver : itfErrorReceiver;
            _errorReceiver2 : itfErrorReceiver;
        END_VAR

        // Reads the cyclic signal and updates the internal state of the endswitch.
        METHOD PUBLIC Update
            VAR_INPUT
                signal : BOOL;       // Current signal state.
                valid : BOOL := TRUE; // Indicates if the signal is valid.
                default : BOOL := FALSE; // Default signal state.
            END_VAR

            _binSignal.ReadCyclic(signal := signal, valid := valid, default := default);
            _binSignal.invert := Behavior = EndswitchBehavior#NormallyClosed;
            _monTimer();
            _errorState := THIS.Check();
        END_METHOD

        METHOD PRIVATE Check : SuperVisionError
            CASE _superVisionMode OF
                SuperVisionMode#None:
                    Check := SuperVisionError#None;
                SuperVisionMode#Action:
                    _monTimer(signal := TRUE, duration := SuperVisionTimeAction);

                    // Error 
                    IF _monTimer.output THEN
                        Check := SuperVisionError#ActionError;
                        _errorReceiver.OnNotification();
                    END_IF;
                SuperVisionMode#Reaction:
                    _monTimer(signal := TRUE, duration := SuperVisionTimeReaction);
                    // Error 
                    IF _monTimer.output THEN
                        _errorReceiver.OnNotification();
                        Check := SuperVisionError#ResponseError;
                    END_IF;
                SuperVisionMode#PositionControl:
                    IF _binSignal.QFal() OR _binSignal.QRis() THEN
                        _errorReceiver.OnNotification();
                        Check := SuperVisionError#PositionError;
                    END_IF;
            END_CASE;
            ;
        END_METHOD

        // Returns the error status of the endswitch 
        METHOD PUBLIC GetError : SuperVisionError
            GetError := _errorState;
        END_METHOD

        // Starts monitoring the endswitch with a specified monitoring time.
        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR
            _superVisionMode := Mode;
            _monTimer(signal := FALSE);
        END_METHOD

        // Checks if the monitoring time has elapsed.
        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := _monTimer.output;
        END_METHOD

        // Checks if the endswitch is currently activated.
        METHOD PUBLIC IsActivated : BOOL
            IsActivated := _binSignal.Q();
            ;
        END_METHOD

        // Checks if the endswitch has been reached.
        METHOD PUBLIC HasReached : BOOL
            HasReached := _binSignal.QRis();
            ;
        END_METHOD

        // Checks if the endswitch has been left.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := _binSignal.QFal();
            ;
        END_METHOD
    
        METHOD PUBLIC Attach
            VAR_INPUT
                er : itfErrorReceiver;
            END_VAR
            IF (_errorReceiver = NULL) THEN
                _errorReceiver := er;
            ELSIF _errorReceiver2 = NULL THEN
                _errorReceiver2 := er;
            ELSE
                // No capacity
                ;
            END_IF;
            ;
        END_METHOD

        METHOD PRIVATE Notify
            _errorReceiver.OnNotification();
            _errorReceiver2.OnNotification();
        END_METHOD
    END_CLASS

END_NAMESPACE
