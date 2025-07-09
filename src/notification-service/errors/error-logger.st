USING System.Strings;
USING System.Math;
USING NotificationService.Interfaces;

NAMESPACE NotificationService
    NAMESPACE ErrorHandling
        CLASS ErrorLogger IMPLEMENTS ILogger
            VAR CONSTANT
                LOW_ARR_BOUND : INT := 1;
                UP_ARR_BOUND : INT := 12;
            END_VAR
        
            VAR PROTECTED
                _messages : ARRAY[LOW_ARR_BOUND..UP_ARR_BOUND] OF Alarm;
                _currentFreeIndex : INT := LOW_ARR_BOUND;
            END_VAR
            
            METHOD PUBLIC Log
                VAR_INPUT
                    e : Alarm;
                END_VAR
                _messages[_currentFreeIndex] := e;
                _currentFreeIndex := _currentFreeIndex + 1;
                
                IF _currentFreeIndex > UP_ARR_BOUND THEN
                    _currentFreeIndex := LOW_ARR_BOUND;
                END_IF;
            END_METHOD
        
            METHOD PUBLIC GetLatestAlarms
                VAR_INPUT
                    severityFilter : Severity;
                END_VAR
                VAR_IN_OUT
                    messages : ARRAY[*] OF Alarm;
                END_VAR
                VAR_TEMP
                    requiredMessagesCount, availableMessagesCount : INT;
                    targetIndex, sourceIndex, transferCount : INT;
                    i : INT;
                END_VAR
                
                requiredMessagesCount := TO_INT(UPPER_BOUND(messages, 1) - LOWER_BOUND(messages, 1)) + 1;
                availableMessagesCount := UP_ARR_BOUND - LOW_ARR_BOUND + 1;
        
                // calculate the source index from which to start
                sourceIndex := _currentFreeIndex - 1;        
                IF sourceIndex < LOW_ARR_BOUND THEN
                    sourceIndex := UP_ARR_BOUND;
                END_IF;
        
                IF _currentFreeIndex > LOW_ARR_BOUND THEN
                    availableMessagesCount := _currentFreeIndex - LOW_ARR_BOUND;
               END_IF;
                
                // determine the minimum possible amount of messages to be transfered
                transferCount := Min(requiredMessagesCount, availableMessagesCount);
                
                // Copy messages, starting from the newest
                FOR i := 0 TO transferCount - 1 DO
                    targetIndex := TO_INT(LOWER_BOUND(messages, 1)) + i;
        
                    messages[targetIndex] := _messages[sourceIndex];
                    
                    sourceIndex := sourceIndex - 1;
                    IF sourceIndex < LOW_ARR_BOUND THEN
                        sourceIndex := UP_ARR_BOUND;
                    END_IF;
                END_FOR;
            END_METHOD
        END_CLASS
    END_NAMESPACE
END_NAMESPACE

