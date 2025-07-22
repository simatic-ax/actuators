NAMESPACE Simatic.Ax.Actuators

    // Enumeration representing the possible states of an actuator.
    TYPE
        ActuatorState : (
            InHomePosition,       // 0: Actuator is in the home position.
            MoveToWorkPosition,   // 1: Actuator is moving to the first work position.
            MoveToWorkPosition2,  // 2: Actuator is moving to the second work position.
            InWorkPosition,       // 3: Actuator is in the first work position.
            InWorkPosition2,      // 4: Actuator is in the second work position.
            MoveToHomePosition,   // 5: Actuator is moving to the home position.
            Error,                // 6: Actuator is in an error state.
            Undefined             // 7: Actuator state is undefined.
        ) := Undefined;
    END_TYPE

END_NAMESPACE
