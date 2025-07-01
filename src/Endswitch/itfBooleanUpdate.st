USING System.Timer;
USING Simatic.Ax.IO.Input;
NAMESPACE Simatic.Ax.Actuators    
    
    INTERFACE itfBooleanUpdate
        // Reads the cyclic signal and updates the internal state of the endswitch.
        METHOD Update
            VAR_INPUT
                signal : BOOL;       // Current signal state.
                valid : BOOL := TRUE; // Indicates if the signal is valid.
                default : BOOL := FALSE; // Default signal state.
            END_VAR
        END_METHOD
    END_INTERFACE

    /// Class representing an endswitch with monitoring logic.
    /// Input: None (set mode via SetMode, update via Update method)
    /// Returns: MonitoringError via Update method
    // CLASS Monitoring IMPLEMENTS itfMonitorig
    //     VAR PUBLIC
    //         /// Defines whether the endswitch is normally open or closed.
    //         Behavior : EndswitchBehavior;
    //         /// Zeitfenster für ResponseMonitoring
    //         Su : LTIME := LTIME#5s;
    //     END_VAR
        
    //     VAR
    //         /// Timer für Monitoring
    //         _monitoringTime : Ondelay;
    //         /// Aktueller Monitoring-Modus
    //         _monitoringMode : MonitoringMode;
    //         /// Letzter bekannter Wert für PositionMonitoring
    //         _lastSignal : BOOL := FALSE;
    //         /// Status für ResponseMonitoring
    //         _responseTimerActive : BOOL := FALSE;
    //         _responseTimerStart : LTIME := LTIME#0ms;
    //         _responseSignalChanged : BOOL := FALSE;
    //         /// Letzter ermittelter MonitoringError-Status
    //         _lastErrorState : MonitoringError := MonitoringError#None;
    //     END_VAR

    //     /// Sets the monitoring mode for the endswitch.
    //     /// Input: MonitoringMode - The mode to set for monitoring.
    //     /// Returns: None.
    //     METHOD PUBLIC SetMode
    //         VAR_INPUT
    //             MonitoringMode : MonitoringMode;
    //         END_VAR
    //         _monitoringMode := MonitoringMode;
    //     END_METHOD

    //     /// Updates the monitoring logic with the current binary signal interface.
    //     /// Input: signal - Interface ItfBinSignal, providing Q, QRis, QFal, QBad methods.
    //     /// Returns: MonitoringError - The result of the monitoring check.
    //     METHOD PUBLIC Update : MonitoringError
    //         VAR_INPUT
    //             signal : ItfBinSignal; // Binary signal interface
    //         END_VAR
    //         // PositionMonitoring: Wert darf sich nicht ändern
    //         IF (_monitoringMode AND MonitoringMode#PositionMonitoring) <> WORD#16#0 THEN
    //             IF signal.QFal() OR signal.QRis() THEN
    //                 _lastErrorState := MonitoringError#PositionError;
    //                 Update := _lastErrorState;
    //                 RETURN;
    //             END_IF;
    //         END_IF;
    //         // ResponseMonitoring: Wert muss sich innerhalb ResponseMonitoringTime ändern
    //         IF (_monitoringMode AND MonitoringMode#ResponseMonitoring) <> WORD#16#0 THEN
    //             IF NOT _responseTimerActive THEN
    //                 _responseTimerActive := TRUE;
    //                 // Timer starten mit signal als signal-Parameter
    //                 _monitoringTime(signal := signal.Q(), duration := ResponseMonitoringTime);
    //                 _responseSignalChanged := FALSE;
    //             ELSE
    //                 // Timer zyklisch aufrufen mit signal als signal-Parameter
    //                 _monitoringTime(signal := signal.Q(), duration := ResponseMonitoringTime);
    //             END_IF;

    //             IF signal.QFal() OR signal.QRis() THEN
    //                 _responseSignalChanged := TRUE;
    //             END_IF;

    //             IF _monitoringTime.output THEN
    //                 IF NOT _responseSignalChanged THEN
    //                     _responseTimerActive := FALSE;
    //                     _monitoringTime(signal := FALSE); // Timer stoppen
    //                     _lastErrorState := MonitoringError#ResponseError;
    //                     Update := _lastErrorState;
    //                     RETURN;
    //                 ELSE
    //                     _responseTimerActive := FALSE;
    //                     _monitoringTime(signal := FALSE); // Timer stoppen
    //                 END_IF;
    //             END_IF;
    //         ELSE
    //             _responseTimerActive := FALSE;
    //             _monitoringTime(signal := FALSE); // Timer stoppen, falls nicht aktiv
    //         END_IF;
    //         // ActionMonitoring: keine Aktion
    //         // ...nichts zu tun...
    //         _lastErrorState := MonitoringError#None;
    //         Update := _lastErrorState;
    //         RETURN;
    //     END_METHOD


    // END_CLASS

END_NAMESPACE
