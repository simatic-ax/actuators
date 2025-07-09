NAMESPACE NotificationService
    NAMESPACE ErrorHandling
        // Basis Fehlertyp
        TYPE Alarm :
            STRUCT
                id : STRING;
                messageSeverity : Severity;
                source : STRING;
                errorMessage : STRING;
                timestamp : DATE_AND_TIME;
            END_STRUCT;

            Severity : (Info, Warning, Error);
        END_TYPE
    END_NAMESPACE
    
END_NAMESPACE

