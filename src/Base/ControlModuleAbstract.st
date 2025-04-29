USING Simatic.Ax.Commands;

NAMESPACE Simatic.Ax.AutomationFramework
    
    ///Provides basic functionality for programming on a plc
    /// has acces to the protected Methods and "Contructors" of the classes
    CLASS ABSTRACT ExecuteControlModuleAbstract EXTENDS Command
        VAR PROTECTED
            _init : BOOL;
        END_VAR
        
        METHOD PROTECTED OVERRIDE Execute
            IF (NOT _init) THEN
                THIS._initmethod();
                _init := TRUE;
            END_IF;
           THIS._executeTypeSpecific();
            ;
        END_METHOD

        METHOD PROTECTED ABSTRACT _executeTypeSpecific
            
        END_METHOD

        METHOD PROTECTED ABSTRACT _initmethod
            
        END_METHOD

    END_CLASS
    
END_NAMESPACE