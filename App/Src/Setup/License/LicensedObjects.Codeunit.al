codeunit 80000 "C4BC Licensed Objects" implements "C4BC IObject Licensing"
{
    /// <summary> 
    /// Specifies whether the objects are licensed or are free to use
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure IsLicensed(): Boolean
    begin
        exit(true);
    end;
}