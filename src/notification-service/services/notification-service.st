USING System.Strings;
USING NotificationService.Interfaces;
USING NotificationService.ErrorHandling;

NAMESPACE NotificationService
    TYPE ComponentRelation :
        STRUCT
            parent : IAlarmProvider;
            child : IAlarmProvider;
        END_STRUCT;
    END_TYPE
    
    // Zentraler Notification Service
    CLASS HierarchicalNotificationService IMPLEMENTS INotificationService
        VAR
            // Speichert die Hierarchie der Komponenten
            // Initialize to NULL for every element
            _componentHierarchy : ARRAY[LOW_ARR_BOUND..UP_ARR_BOUND] OF ComponentRelation;
            _errorLogger : ILogger;
            _numRelations : INT;
        END_VAR
    
        VAR CONSTANT
            LOW_ARR_BOUND : INT := 1;
            UP_ARR_BOUND : INT := 12;
        END_VAR
    
        METHOD PUBLIC RegisterLogger : BOOL
            VAR_INPUT
                logger : ILogger;
            END_VAR
            
            RegisterLogger := FALSE;
            IF logger = NULL THEN
                RETURN;
            END_IF;
    
            _errorLogger := logger;
            RegisterLogger := TRUE;
        END_METHOD
        METHOD PUBLIC RegisterHierarchy : BOOL
            VAR_INPUT
                parent, child : IAlarmProvider;
            END_VAR
            VAR_TEMP
                freeIndex : INT := -1;
                i : INT := 0;
            END_VAR
    
            // no capacity left
            IF _numRelations >= UP_ARR_BOUND THEN
                RegisterHierarchy := FALSE;
                RETURN;
            END_IF;
    
            IF parent = NULL OR child = NULL THEN
                RegisterHierarchy := FALSE;
                RETURN;
            END_IF;
    
            // entry already existing
            FOR i := LOW_ARR_BOUND TO UP_ARR_BOUND DO
                IF THIS.EntryCouldBeFound(_componentHierarchy[i], parent, child) THEN
                    RegisterHierarchy := FALSE;
                    RETURN;
                END_IF;
                IF freeIndex = -1 AND _componentHierarchy[i].child = NULL AND _componentHierarchy[i].parent = NULL THEN
                    freeIndex := i;
                    EXIT;
                END_IF;
            END_FOR;
                
            _componentHierarchy[freeIndex].child := child;
            _componentHierarchy[freeIndex].parent := parent;
            _numRelations := _numRelations + 1;
            RegisterHierarchy := TRUE;
        END_METHOD
    
        METHOD PUBLIC UnregisterHierarchy : BOOL
            VAR_INPUT
                parent, child : IAlarmProvider;
            END_VAR
            VAR_TEMP
                i : INT;
            END_VAR
            
            UnregisterHierarchy := FALSE;
    
            IF _numRelations <= 0 THEN
                UnregisterHierarchy := FALSE;
            ELSE
                FOR i := LOW_ARR_BOUND TO UP_ARR_BOUND DO
                    IF THIS.EntryCouldBeFound(_componentHierarchy[i], parent, child) THEN
                        _componentHierarchy[i].parent := NULL;
                        _componentHierarchy[i].child := NULL;
                        _numRelations := _numRelations - 1;
                        UnregisterHierarchy := TRUE;
                        EXIT;
                    END_IF;
                END_FOR;
            END_IF;
        END_METHOD
    
        METHOD PRIVATE EntryCouldBeFound : BOOL
            VAR_INPUT
                item : ComponentRelation;
                parent, child: IAlarmProvider;
            END_VAR
    
            EntryCouldBeFound := FALSE;
            IF item.child <> NULL AND item.parent <> NULL THEN
                IF item.parent.Equals(parent) AND item.child.Equals(child) THEN
                    EntryCouldBeFound := TRUE;
                END_IF;
            END_IF;
        END_METHOD
    
        METHOD PUBLIC RegisterAlarm : BOOL
            VAR_INPUT
                source : IAlarmProvider;
                componentAlarm : Alarm;
            END_VAR
            VAR
                i : INT;
                foundChild : BOOL;
            END_VAR
    
            RegisterAlarm := FALSE;
    
            // do not register any error in case there is no one to notify
            IF _numRelations < LOW_ARR_BOUND THEN
                RegisterAlarm := FALSE;
                RETURN;
            END_IF;
    

            foundChild := FALSE;
            // locate the childs index first
            // a child may have been associated to multiple parents for notification
            FOR i := LOW_ARR_BOUND TO UP_ARR_BOUND DO
                IF _componentHierarchy[i].child <> NULL THEN
                    IF _componentHierarchy[i].child.Equals(source) THEN
                        _componentHierarchy[i].parent.Notify(componentAlarm);
                        RegisterAlarm := TRUE;
                        foundChild := TRUE;
                    END_IF;
                END_IF;
            END_FOR;
            IF NOT foundChild THEN
                _errorLogger.Log(componentAlarm);
            END_IF;
            // // locate the childs index first
            // // a child may have been associated to multiple parents for notification
            // FOR i := LOW_ARR_BOUND TO UP_ARR_BOUND DO
            //     IF _componentHierarchy[i].child <> NULL THEN
            //         IF _componentHierarchy[i].child.Equals(source) THEN
            //             _componentHierarchy[i].parent.Notify(componentAlarm);
            //             RegisterAlarm := TRUE;
            //         ELSE
            //             // we've reached the root -> we may now assemble and store the final message
            //             _errorLogger.Log(componentAlarm);
            //             ;
            //         END_IF;
            //     END_IF;
            // END_FOR;
        END_METHOD
    
        METHOD PUBLIC ClearHierarchy
            VAR_TEMP
                i : INT;
            END_VAR
            FOR i := LOW_ARR_BOUND TO UP_ARR_BOUND DO
                _componentHierarchy[i].child := NULL;
                _componentHierarchy[i].parent := NULL;
            END_FOR;
        END_METHOD
    
    END_CLASS
END_NAMESPACE
