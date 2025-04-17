USING Simatic.Ax.IO.Input;
USING System.Timer;

NAMESPACE Simatic.Ax.Actuators    

    // Dummy implementation of the ItfEndswitch interface for testing purposes.
    CLASS INTERNAL NullEndswitch IMPLEMENTS itfEndswitch
        VAR PUBLIC
            MonitoringTime : LTIME := T#5s; // Default monitoring time.
        END_VAR

        VAR
            _monTimer : Ondelay;       // Timer for monitoring.
            _hasActivated : BOOL;     // Indicates if the endswitch has been activated.
            _hasLeft : BOOL;          // Indicates if the endswitch has been left.
            _activatedOld : BOOL;     // Previous activation state.
        END_VAR

        // Reads the cyclic signal and updates the internal state of the dummy endswitch.
        METHOD PUBLIC ReadCyclic
            _monTimer();
            _hasActivated := _monTimer.output AND NOT(_activatedOld);
            _hasLeft := NOT(_monTimer.output) AND _activatedOld;
            _activatedOld := _monTimer.output;
        END_METHOD

        // Starts monitoring the dummy endswitch with a specified monitoring time.
        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME := T#5S; // Default monitoring time.
            END_VAR
            
            _monTimer(signal := FALSE);
            _monTimer(signal := TRUE, duration := MonitoringTime);
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
            HasReached := _hasActivated;
        END_METHOD

        // Checks if the dummy endswitch has been left.
        METHOD PUBLIC HasLeft : BOOL
            HasLeft := _hasLeft;
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE
