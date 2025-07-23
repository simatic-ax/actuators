USING NotificationService.ErrorHandling;

NAMESPACE NotificationService.Interfaces
    // Interface für Vergleichsoperationen
    INTERFACE IComparable
    METHOD Equals : BOOL
        VAR_INPUT
            other : IComparable;
        END_VAR
    END_METHOD
    END_INTERFACE

    // Basis Interface für Fehlerbenachrichtigungen
    INTERFACE IAlarmProvider EXTENDS IComparable
    METHOD Notify : BOOL
        VAR_INPUT
            e : Alarm;
        END_VAR
    END_METHOD

    METHOD SetNotificationService
        VAR_INPUT
            ns : INotificationService;
        END_VAR
    END_METHOD

    METHOD OnNotification END_METHOD

    METHOD GetId : STRING END_METHOD
    END_INTERFACE    

    INTERFACE INotificationService

    /// Allows registering a parent child relation to the service for later notification
    /// Returns false on
    /// exceeded capacity
    /// duplicate entries
    METHOD RegisterHierarchy : BOOL
        VAR_INPUT
            parent, child : IAlarmProvider;
        END_VAR
    END_METHOD

    METHOD UnregisterHierarchy : BOOL
        VAR_INPUT
            parent, child : IAlarmProvider;
        END_VAR
    END_METHOD

    METHOD RegisterAlarm : BOOL
        VAR_INPUT
            source : IAlarmProvider;
            componentAlarm : Alarm;
        END_VAR
    END_METHOD

    METHOD RegisterLogger : BOOL
        VAR_INPUT
            logger : ILogger;
        END_VAR
    END_METHOD

    METHOD ClearHierarchy END_METHOD    
    END_INTERFACE

    INTERFACE ILogger
    METHOD Log
        VAR_INPUT
            e : Alarm;
        END_VAR        
    END_METHOD

    METHOD GetLatestAlarms
        VAR_INPUT
            severityFilter : Severity;
        END_VAR
        VAR_IN_OUT
            messages : ARRAY[*] OF Alarm;
        END_VAR
    END_METHOD
    END_INTERFACE
END_NAMESPACE

