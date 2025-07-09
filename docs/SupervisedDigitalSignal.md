# SupervisedBooleanSignal

## Description

The class `BooleanEndswitch` represents a supervised digital endswitch for automation systems. It encapsulates the logic for monitoring the state of a digital sensor (such as a limit switch) and provides supervision features for different operational modes.

### Purpose and Usage

- **Purpose:**
  - The `BooleanEndswitch` class is used to monitor and supervise the state of a digital input signal, typically representing a physical endswitch or sensor in an automation environment.
  - It supports supervision modes such as position control, action monitoring, and reaction monitoring, allowing detection of errors like missing activation, delayed response, or unexpected state changes.

- **Typical Use Cases:**
  - Detecting whether a mechanical actuator has reached its end position.
  - Supervising the timely response of a sensor after a command is given.
  - Monitoring for stuck or faulty sensors by checking for unexpected or missing state transitions.

- **Features:**
  - Implements the interfaces `itfEndswitch` and `itfBooleanUpdate` for standardized access and update mechanisms.
  - Provides methods to enable supervision, check activation, and query error states.
  - Supports configuration of supervision times for action and reaction monitoring.

---

```mermaid
classDiagram
    class itfEndswitch {
        <<interface>>
        +EnableSupervision(Mode : SuperVisionMode)
        +IsActivated() BOOL
        +HasReached() BOOL
        +HasLeft() BOOL
        +TimeHasElapsed() BOOL
    }
    class itfBooleanUpdate {
        <<interface>>
        +Update(signal : BOOL, valid : BOOL, default : BOOL)
    }
    class BooleanEndswitch {
        +Behavior : EndswitchBehavior
        +SuperVisionTimeAction : LTIME
        +SuperVisionTimeReaction : LTIME
        -_binSignal : BinSignal
        -_monTimer : Ondelay
        -_errorState : SuperVisionError
        -_superVisionMode : SuperVisionMode
        +Update(signal : BOOL, valid : BOOL, default : BOOL)
        -Check() : SuperVisionError
        +EnableSupervision(Mode : SuperVisionMode)
        +TimeHasElapsed() : BOOL
        +IsActivated() : BOOL
        +HasReached() : BOOL
        +HasLeft() : BOOL
    }
    BooleanEndswitch ..|> itfEndswitch
    BooleanEndswitch ..|> itfBooleanUpdate
```

---

## Messaging Mechanism Class Diagram

The following diagram shows die Vererbung und Beziehungen des Messaging-Mechanismus (Notify/OnNotification):

```mermaid
classDiagram
    class Info {
        +Name : STRING[20]
        +ErrorMessage : STRING[40]
    }
    class itfErrorReceiver {
        <<interface>>
        +OnNotification(i : Info)
    }
    class itfErrorProvider {
        <<interface>>
        +Attach(er : itfErrorReceiver)
    }
    class ControlModuleAbstract {
        -_errorReceiver : itfErrorReceiver
        +Attach(er : itfErrorReceiver)
        +Notify(i : Info)
        +OnNotification(i : Info)
    }
    class Actuator2Way {
        +OnNotification(i : Info)
    }
    class Actuator3Way {
        +OnNotification(i : Info)
    }
    class TimeBasedActuator {
        +OnNotification(i : Info)
    }
    ControlModuleAbstract ..|> itfErrorProvider
    ControlModuleAbstract ..|> itfErrorReceiver
    Actuator2Way --|> ControlModuleAbstract
    Actuator3Way --|> ControlModuleAbstract
    TimeBasedActuator --|> ControlModuleAbstract
    itfErrorProvider <|.. ControlModuleAbstract
    itfErrorReceiver <|.. ControlModuleAbstract
    itfErrorReceiver <|.. Actuator2Way
    itfErrorReceiver <|.. Actuator3Way
    itfErrorReceiver <|.. TimeBasedActuator
    Info <.. itfErrorReceiver : uses
    Info <.. ControlModuleAbstract : uses
```
