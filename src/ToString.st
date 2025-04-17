NAMESPACE Simatic.Ax.Actuators

    FUNCTION ToString : STRING
        VAR_INPUT
            val : ActuatorState;
        END_VAR
        CASE val OF
            ActuatorState#InHomePosition:
                ToString := 'InHomePosition';
                RETURN;
            ActuatorState#MoveToWorkPosition:
                ToString := 'MoveToWorkPosition';
                RETURN;
            ActuatorState#MoveToWorkPosition2:
                ToString := 'MoveToWorkPosition2';
                RETURN;
            ActuatorState#InWorkPosition:
                ToString := 'InWorkPosition';
                RETURN;
            ActuatorState#InWorkPosition2:
                ToString := 'InWorkPosition2';
                RETURN;
            ActuatorState#MoveToHomePosition:
                ToString := 'MoveToHomePosition';
                RETURN;
            ActuatorState#Error:
                ToString := 'Error';
                RETURN;
            ActuatorState#Undefined:
                ToString := 'Undefined';
                RETURN;
        END_CASE;
        ;
    END_FUNCTION

END_NAMESPACE
