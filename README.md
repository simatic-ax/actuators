# @simatic-ax/actuators

## Description

This library provides a set of classes, interfaces, and types for controlling actuators in industrial automation systems. It simplifies the implementation of control logic for applications by following the PLC Open mechanisms, making it easy to use.

The following actuators are available:
- `Actuator2Way`: A 2-way actuator that moves between two positions: Home and Work1.
- `Actuator3Way`: A 3-way actuator that moves between three positions: Home, Work1, and Work2.

## Getting started

Install with Apax:

> If not yet done login to the GitHub registry first.
> More information you'll find [here](https://github.com/simatic-ax/.github/blob/main/docs/personalaccesstoken.md)

```cli
apax add @simatic-ax/actuators
```

Add the namespace in your ST code:

```iec-st
Using Simatic.Ax.Actuator;
```

## Actuators

### Classes

| Class               | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `Actuator2Way`      | Represents a 2-way actuator that can move between two positions: Home and Work. |
| `Actuator3Way`      | Represents a 3-way actuator that can move between three positions: Home, Work1, and Work2. |

#### Public Variables for `Actuator2Way`

| Variable            | Type              | Description                                                                 |
|---------------------|-------------------|-----------------------------------------------------------------------------|
| `I_InHomePosition`  | `itfEndswitch`    | End switch indicating the actuator is in the home position.                 |
| `I_InWorkPosition`  | `itfEndswitch`    | End switch indicating the actuator is in the work position.                 |
| `Q_ToHomePosition`  | `itfPosition`     | Command to move the actuator to the home position.                          |
| `Q_ToWorkPosition`  | `itfPosition`     | Command to move the actuator to the work position.                          |
| `TMonToWorkPosition`| `LTIME`           | Monitoring time for moving to the work position. Default: `T#5s`.           |
| `TMonToHomePosition`| `LTIME`           | Monitoring time for moving to the home position. Default: `T#5s`.           |

#### Methods for `Actuator2Way` (including inherited methods)

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `GoToHomePosition`  | None                           | `itfCommand` | Command to move the actuator to the home position.                         |
| `GoToWorkPosition`  | None                           | `itfCommand` | Command to move the actuator to the first work position.                   |
| `GetState`          | None                           | `ActuatorState` | Retrieves the current state of the actuator.                              |

#### Public Variables for `Actuator3Way`

| Variable            | Type              | Description                                                                 |
|---------------------|-------------------|-----------------------------------------------------------------------------|
| `I_InHomePosition`  | `itfEndswitch`    | End switch indicating the actuator is in the home position.                 |
| `I_InWorkPosition`  | `itfEndswitch`    | End switch indicating the actuator is in the first work position.           |
| `I_InWorkPosition2` | `itfEndswitch`    | End switch indicating the actuator is in the second work position.          |
| `Q_ToHomePosition`  | `itfPosition`     | Command to move the actuator to the home position.                          |
| `Q_ToWorkPosition`  | `itfPosition`     | Command to move the actuator to the first work position.                    |
| `Q_ToWorkPosition2` | `itfPosition`     | Command to move the actuator to the second work position.                   |
| `TMonToWorkPosition`| `LTIME`           | Monitoring time for moving to the first work position. Default: `T#5s`.     |
| `TMonToHomePosition`| `LTIME`           | Monitoring time for moving to the home position. Default: `T#5s`.           |

#### Methods for `Actuator3Way` (including inherited methods)

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `GoToHomePosition`  | None                           | `itfCommand` | Command to move the actuator to the home position.                         |
| `GoToWorkPosition`  | None                           | `itfCommand` | Command to move the actuator to the first work position.                   |
| `GoToWorkPosition2` | None                           | `itfCommand` | Command to move the actuator to the second work position.                  |
| `GetState`          | None                           | `ActuatorState` | Retrieves the current state of the actuator.                              |

### Interfaces

| Interface           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `itfActuator`       | Defines methods for controlling actuator states and retrieving their current state. |

#### Methods for `itfActuator`

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `GoToHomePosition`  | None                           | `itfCommand` | Command to move the actuator to the home position.                         |
| `GoToWorkPosition`  | None                           | `itfCommand` | Command to move the actuator to the first work position.                   |
| `GoToWorkPosition2` | None                           | `itfCommand` | Command to move the actuator to the second work position.                  |
| `GetState`          | None                           | `ActuatorState` | Retrieves the current state of the actuator.                              |

### Types

| Type                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `ActuatorState`     | Enumeration representing the possible states of an actuator.               |
|                     | - `InHomePosition`: The actuator is in its home or default position.       |
|                     | - `MoveToWorkPosition`: The actuator is moving to its designated work position. |
|                     | - `MoveToWorkPosition2`: The actuator is moving to its second work position (for 3-way actuators). |
|                     | - `InWorkPosition`: The actuator is in its first work position.            |
|                     | - `InWorkPosition2`: The actuator is in its second work position (for 3-way actuators). |
|                     | - `MoveToHomePosition`: The actuator is moving back to its home position.  |
|                     | - `Error`: The actuator has encountered an error.                         |
|                     | - `Undefined`: The actuator's state is undefined or indeterminate.         |

---

## ActuatorControl

### Class

| Class               | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `ActuatorControl`   | Provides control logic for actuator positions, including setting, holding, and resetting positions. |

#### Public Variables for `ActuatorControl`

| Variable            | Type              | Description                                                                 |
|---------------------|-------------------|-----------------------------------------------------------------------------|
| `Behavior`          | `PositionBehavior`| Defines the behavior of the actuator position: `ActiveHold` or `SelfHold`. |

#### Methods for `ActuatorControl`

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `WriteCyclic`       | `Q: BOOL` (output)             | None         | Writes the cyclic output signal.                                           |
| `Set`               | None                           | `BOOL`       | Sets the actuator position to active.                                      |
| `Reset`             | None                           | `BOOL`       | Resets the actuator position to inactive.                                  |
| `Hold`              | None                           | `BOOL`       | Holds the actuator position based on the configured behavior.              |

### Interfaces

| Interface           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `itfPosition`       | Defines methods for setting, holding, and resetting actuator positions.     |

#### Methods for `itfPosition`

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `Set`               | None                           | `BOOL`       | Sets the actuator position to active.                                      |
| `Reset`             | None                           | `BOOL`       | Resets the actuator position to inactive.                                  |
| `Hold`              | None                           | `BOOL`       | Holds the actuator position based on the configured behavior.              |

### Types

| Type                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `PositionBehavior`  | Enumeration defining position behavior.                                    |
|                     | - `ActiveHold`: The actuator actively holds its position.                 |
|                     | - `SelfHold`: The actuator maintains its position without active control. |

---

## End Switches

### Classes

| Class               | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `Endswitch`         | Represents an end switch with monitoring capabilities.                     |

#### Public Variables for `Endswitch`

| Variable            | Type              | Description                                                                 |
|---------------------|-------------------|-----------------------------------------------------------------------------|
| `Behavior`          | `Behavior`        | Defines whether the end switch is `NormallyOpen` or `NormallyClosed`.       |

#### Methods for `Endswitch`

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `ReadCyclic`        | `signal: BOOL`, `valid: BOOL`, `default: BOOL` | None | Reads the cyclic signal and updates the internal state of the end switch.  |
| `StartMonitoring`   | `MonitoringTime: LTIME`        | None         | Starts monitoring the end switch with a specified monitoring time.         |
| `TimeHasElapsed`    | None                           | `BOOL`       | Checks if the monitoring time has elapsed.                                 |
| `IsActivated`       | None                           | `BOOL`       | Checks if the end switch is currently activated.                           |
| `HasReached`        | None                           | `BOOL`       | Checks if the end switch has been reached.                                 |
| `HasLeft`           | None                           | `BOOL`       | Checks if the end switch has been left.                                    |

### Interfaces

| Interface           | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `itfEndswitch`      | Defines methods for monitoring and retrieving the state of an end switch.   |

#### Methods for `itfEndswitch`

| Method              | Parameters                     | Return Value | Description                                                                 |
|---------------------|---------------------------------|--------------|-----------------------------------------------------------------------------|
| `StartMonitoring`   | `MonitoringTime: LTIME`        | None         | Starts monitoring the end switch with a specified monitoring time.         |
| `IsActivated`       | None                           | `BOOL`       | Checks if the end switch is currently activated.                           |
| `HasReached`        | None                           | `BOOL`       | Checks if the end switch has been reached.                                 |
| `HasLeft`           | None                           | `BOOL`       | Checks if the end switch has been left.                                    |
| `TimeHasElapsed`    | None                           | `BOOL`       | Checks if the monitoring time has elapsed.                                 |

### Types

| Type                | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `Behavior`          | Enumeration representing the behavior of an end switch.                   |
|                     | - `NormallyOpen`: The end switch is open by default and closes when activated. |
|                     | - `NormallyClosed`: The end switch is closed by default and opens when activated. |

---

## Contribution

Thanks for your interest in contributing. Anybody is free to report bugs, unclear documentation, and other problems regarding this repository in the Issues section or, even better, is free to propose any changes to this repository using Merge Requests.

## Markdownlint-cli

This workspace will be checked by the [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) (there is also documented how to install the tool) tool in the CI workflow automatically.
To avoid, that the CI workflow fails because of the markdown linter, you can check all markdown files locally by running the markdownlint with:

```sh
markdownlint **/*.md --fix
```

## License and Legal information

Please read the [Legal information](LICENSE.md)
