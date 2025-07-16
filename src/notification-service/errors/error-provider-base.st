USING System.Strings;
USING NotificationService.Interfaces;
USING Simatic.Ax.Commands;

NAMESPACE NotificationService
    NAMESPACE ErrorHandling 
        CLASS ErrorProviderBase IMPLEMENTS IAlarmProvider
            VAR PUBLIC
                _id : STRING;
                _name : STRING;
                
            END_VAR
        
            VAR PUBLIC
                _notificationService : INotificationService;
            END_VAR
        
            METHOD PUBLIC SetNotificationService
                VAR_INPUT
                    ns : INotificationService;
                END_VAR
                _notificationService := ns;
            END_METHOD
            
            METHOD PUBLIC Notify : BOOL
                VAR_INPUT
                    e : Alarm;
                END_VAR
        
                VAR_TEMP
                    t : Alarm;
                END_VAR
                t := e;
                IF e.source = '' THEN
                    t.source := _name;
                ELSE
                    t.source := Concat(_name, '.', e.source);
                END_IF;
                IF (_notificationService <> NULL) THEN
                    _notificationService.RegisterAlarm(THIS, t);
                END_IF;
                THIS.OnNotification();
                Notify := TRUE;
            END_METHOD
        
            METHOD PUBLIC OnNotification ; END_METHOD
        
            // // concatenation of bools incorrect
            // METHOD PUBLIC Notify : BOOL
            //     VAR_INPUT
            //         errors : ARRAY[*] OF Alarm;
            //     END_VAR
            //     VAR_TEMP
            //         i, j : DINT := 0;
            //         result : BOOL := FALSE;
            //     END_VAR
            //     i := LOWER_BOUND(errors, 1);
            //     j := UPPER_BOUND(errors, 1);
        
            //     FOR i := LOWER_BOUND(errors, 1) TO UPPER_BOUND(errors, 1) DO
            //         result := _notificationService.RegisterAlarm(THIS, errors[i]);  
            //     END_FOR;
        
            //     THIS.OnNotification();
                
            //     Notify := result;
            // END_METHOD
        
            METHOD PUBLIC Equals : BOOL
                VAR_INPUT
                    other : IComparable;
                END_VAR
                VAR
                    i : REF_TO ErrorProviderBase;
                END_VAR
                IF other = NULL THEN
                    Equals := FALSE;
                    RETURN;
                END_IF;
                i ?= other;
        
                IF i = NULL THEN
                    Equals := FALSE;
                    RETURN;
                END_IF;
        
                IF i^._id <> _id THEN
                    Equals := FALSE;
                    RETURN;
                END_IF;
                Equals := TRUE;
        
            END_METHOD
        
            // just here for the ease of spawning an error
            METHOD PUBLIC Execute
                VAR_INPUT
                    triggerError : BOOL;
                    message : STRING;
                    timestamp : DATE_AND_TIME;
                    sev : Severity;
                END_VAR
                VAR_TEMP
                    e : Alarm;
                END_VAR
        
                IF triggerError THEN
                    e.errorMessage := message;
                    e.timestamp := timestamp;
                    e.messageSeverity := sev;
                    THIS.Notify(e);
                END_IF;
            END_METHOD
        END_CLASS
    END_NAMESPACE    
END_NAMESPACE

