USING Simatic.Ax.Actuators;
USING Simatic.Ax.Actuators;
USING Simatic.Ax.Actuators;
USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.AutomationFramework

    ///Provides basic functionality for programming on a plc
    /// has acces to the protected Methods and "Contructors" of the classes
    CLASS ABSTRACT ExecuteControlModuleAbstract
        EXTENDS ExecuteCommand
        IMPLEMENTS itfErrorProvider, itfErrorReceiver
        VAR PROTECTED
            _init : BOOL;
            _hasError : BOOL;
            _errorState : WORD;
            _exec : BOOL;

        END_VAR
        VAR PRIVATE
            _errorReceiver : itfErrorReceiver;
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

        METHOD PROTECTED Notify
            VAR_INPUT
                i : Info;
            END_VAR
            IF (_errorReceiver <> NULL) THEN
                _errorReceiver.OnNotification();
            END_IF;
        END_METHOD

        METHOD PUBLIC Attach
            VAR_INPUT
                er : itfErrorReceiver;
            END_VAR
            _errorReceiver := er;
            ;
        END_METHOD
        METHOD PUBLIC ABSTRACT OnNotification
            VAR_INPUT
                i : Info;
            END_VAR
        END_METHOD
    END_CLASS

END_NAMESPACE
