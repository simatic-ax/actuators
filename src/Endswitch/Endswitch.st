USING System.Timer;
USING Simatic.Ax.IO.Input;
NAMESPACE Simatic.Ax.Actuators    
    // Class representing an endswitch, implementing the ItfEndswitch interface.
    CLASS Endswitch IMPLEMENTS itfEndswitch
        VAR PUBLIC
            Behavior : EndswitchBehavior; // Defines whether the endswitch is normally open or closed.
        END_VAR
        
        VAR
            _binSignal : BinSignal; // Binary signal for the endswitch.
            _monTimer : Ondelay;    // Timer for monitoring the endswitch.
        END_VAR

        // Reads the cyclic signal and updates the internal state of the endswitch.
        METHOD PUBLIC ReadCyclic
            VAR_INPUT
                signal : BOOL;       // Current signal state.
                valid : BOOL := TRUE; // Indicates if the signal is valid.
                default : BOOL := FALSE; // Default signal state.
            END_VAR

            _binSignal.ReadCyclic(signal := signal, valid := valid, default := default);
            _binSignal.invert := Behavior = EndswitchBehavior#NormallyClosed;
            _monTimer();
        END_METHOD

        // Starts monitoring the endswitch with a specified monitoring time.
        METHOD PUBLIC StartMonitoring
            VAR_INPUT
                MonitoringTime : LTIME := T#5s; // Default monitoring time.
            END_VAR
            
            _monTimer(signal := FALSE);
            _monTimer(signal := TRUE, duration := MonitoringTime);
            ;
        END_METHOD

        METHOD PUBLIC DisableMonitoring
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
