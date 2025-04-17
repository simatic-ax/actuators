NAMESPACE Simatic.Ax.Actuators

    // Enumeration representing the possible states of an actuator.
    TYPE
        ActuatorState : (
            InHomePosition,       // Actuator is in the home position.
            MoveToWorkPosition,   // Actuator is moving to the first work position.
            MoveToWorkPosition2,  // Actuator is moving to the second work position.
            InWorkPosition,       // Actuator is in the first work position.
            InWorkPosition2,      // Actuator is in the second work position.
            MoveToHomePosition,   // Actuator is moving to the home position.
            Error,                // Actuator is in an error state.
            Undefined             // Actuator state is undefined.
        ) := Undefined;
    END_TYPE

END_NAMESPACE
