USING NotificationService.ErrorHandling;
USING System.Timer;
USING Simatic.Ax.IO.Input;
USING NotificationService.ErrorHandling;
NAMESPACE Simatic.Ax.Actuators    
    // Class representing an endswitch, implementing the ItfEndswitch interface.
    CLASS BooleanEndswitch EXTENDS ErrorProviderBase IMPLEMENTS itfEndswitch, itfBooleanUpdate
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
            _isInitialized : BOOL;
            _Alarm : Alarm := (id := '4711', errorMessage := 'Endswitch fault');
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
                        _Alarm.errorMessage := 'Action Error';
                        THIS.Notify(e := _Alarm);
                        _monTimer(signal := FALSE);
                    END_IF;
                SuperVisionMode#Reaction:
                    _monTimer(signal := TRUE, duration := SuperVisionTimeReaction);
                    // Error 
                    IF _monTimer.output THEN
                        _Alarm.errorMessage := 'Reaction Error';
                        THIS.Notify(e := _Alarm);
                        Check := SuperVisionError#ResponseError;
                        _monTimer(signal := FALSE);
                    END_IF;
                SuperVisionMode#PositionControl:
                    IF _binSignal.QFal() OR _binSignal.QRis() THEN
                        _Alarm.errorMessage := 'Position Error';
                        THIS.Notify(e := _Alarm);
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
    
    END_CLASS

END_NAMESPACE
