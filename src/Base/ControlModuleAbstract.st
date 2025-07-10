USING NotificationService.Interfaces;
USING Simatic.Ax.Actuators;
USING Simatic.Ax.Commands;
USING NotificationService.ErrorHandling;
USING System.Strings;
NAMESPACE Simatic.Ax.AutomationFramework

    ///Provides basic functionality for programming on a plc
    /// has acces to the protected Methods and "Contructors" of the classes
    CLASS ABSTRACT ExecuteControlModuleAbstract 
        EXTENDS ExecuteCommand IMPLEMENTS IAlarmProvider
        
        VAR PUBLIC
            _id : STRING;
            _name : STRING;
            _notificationService : INotificationService;
        END_VAR
        VAR PROTECTED
            _init : BOOL;
            _hasError : BOOL;
            _errorState : WORD;
            _exec : BOOL;

        END_VAR


        METHOD PROTECTED OVERRIDE Execute
            IF (NOT _init) THEN
                THIS._initmethod();
                _init := TRUE;
            END_IF;
            THIS._executeTypeSpecific();
            ;
        END_METHOD

        METHOD PROTECTED OVERRIDE SetExecute
            VAR_INPUT
                exec : BOOL;
            END_VAR
            _exec := exec;
            IF (_exec) THEN
                THIS.InitState();
            END_IF;
            ;
        END_METHOD
        METHOD PROTECTED ABSTRACT _executeTypeSpecific
        END_METHOD
        METHOD PROTECTED ABSTRACT _initmethod
        END_METHOD

        METHOD PUBLIC GetErrorStatus : WORD
            GetErrorStatus := _errorState;
        END_METHOD

    
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
            _notificationService.RegisterAlarm(THIS, t);
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
    END_CLASS

END_NAMESPACE
