USING System.Timer;

NAMESPACE Simatic.Ax.Actuators

    // Dummy implementation of the ItfEndswitch interface for testing purposes.
    CLASS INTERNAL NullEndswitch
        IMPLEMENTS itfEndswitch
        VAR PUBLIC
            MonitoringTime : LTIME := T#5s; // Default monitoring time.
        END_VAR
        VAR
            _monTimer : Ondelay; // Timer for monitoring.
            _hasReached : BOOL; // Indicates if the endswitch has been activated.
            _hasLeft : BOOL; // Indicates if the endswitch has been left.
            _activatedOld : BOOL; // Previous activation state.
            /// Current error state of the endswitch.
            _errorState : SuperVisionState;
            /// Current supervision mode of the endswitch.
            _superVisionMode : SuperVisionMode;
        END_VAR
        // Reads the cyclic signal and updates the internal state of the dummy endswitch.

        METHOD PUBLIC ReadCyclic
            _monTimer();
            _hasReached := _monTimer.output AND NOT (_activatedOld);
            _hasLeft := NOT (_monTimer.output) AND _activatedOld;
            _activatedOld := _monTimer.output;
            THIS.Check();
        END_METHOD

        METHOD PRIVATE Check : SuperVisionState
            CASE _superVisionMode OF
                SuperVisionMode#None:
                    Check := _errorState;
                SuperVisionMode#Reaction:
                    _monTimer(signal := TRUE, duration := MonitoringTime);
                    Check := SuperVisionState#EvaluatingRecaction;
                    IF (_hasReached) THEN
                        _superVisionMode := SuperVisionMode#None;
                    END_IF;
                SuperVisionMode#Action:
                    Check := SuperVisionState#EvaluatingAction;
                    IF (_hasLeft) THEN
                        _superVisionMode := SuperVisionMode#None;
                    END_IF;
                    // Error 

                SuperVisionMode#PositionControl:
                    Check := SuperVisionState#EvaluatingPosition;

            END_CASE;
        END_METHOD
        // Starts monitoring the dummy endswitch with a specified monitoring time.

        METHOD PUBLIC EnableSupervision
            VAR_INPUT
                Mode : SuperVisionMode;
            END_VAR
            _errorState := SuperVisionState#None;
            _superVisionMode := Mode;
            _monTimer(signal := FALSE);
            CASE _superVisionMode OF
                SuperVisionMode#Reaction:
                    _monTimer(signal := TRUE, duration := MonitoringTime);
                SuperVisionMode#Action:
                    _superVisionMode := SuperVisionMode#None;
                SuperVisionMode#PositionControl:
                    _superVisionMode := SuperVisionMode#None;
            ELSE
                ;
            END_CASE;
            _monTimer(signal := FALSE);
            ;
        END_METHOD
        // Checks if the monitoring time has elapsed.

        METHOD PUBLIC TimeHasElapsed : BOOL
            TimeHasElapsed := FALSE;
        END_METHOD
        // Checks if the dummy endswitch is currently activated.

        METHOD PUBLIC IsActivated : BOOL
            IsActivated := _monTimer.output;
        END_METHOD
        // Checks if the dummy endswitch has been reached.

        METHOD PUBLIC HasReached : BOOL
            HasReached := _hasReached;
        END_METHOD
        // Checks if the dummy endswitch has been left.

        METHOD PUBLIC HasLeft : BOOL
            HasLeft := _hasLeft;
            ;
        END_METHOD
        // Returns the error status of the endswitch 

        METHOD PUBLIC GetError : SuperVisionState
            GetError := SuperVisionState#None;
        END_METHOD
    END_CLASS

END_NAMESPACE
