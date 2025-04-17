USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.Actuators

    // Interface for actuators, defining methods for controlling actuator states and retrieving their current state.
    INTERFACE itfActuator
        // Command to move the actuator to the home position.
        METHOD GoToHomePosition : itfCommand
        END_METHOD

        // Command to move the actuator to the first work position.
        METHOD GoToWorkPosition : itfCommand
        END_METHOD

        // Command to move the actuator to the second work position.
        METHOD GoToWorkPosition2 : itfCommand
        END_METHOD

        // Retrieves the current state of the actuator.
        METHOD GetState : ActuatorState
        END_METHOD
    END_INTERFACE

END_NAMESPACE
