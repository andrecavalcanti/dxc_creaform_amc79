codeunit 50001 "DXC DIS"
{
    
    trigger OnRun();
    begin
    end;

    local procedure "--CU5100918---"();
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 5100918, 'OnBeforeConvertValueByTag', '', true, true)]
    local procedure HandleBeforeConvertValueByTagOnDISConversionMgt(var SourceCodeTag : Code[20];var FldValue : Variant);
    var
        FirstDate : Date;
        LastDate : Date;
    begin

        case SourceCodeTag of
          'CURRMONTH':
            CurrMonthFilter(FldValue);
          'CRMDATETIME2DATE':
            DateTimeToDate(FldValue);
          'DATE-1D' :
            DatetoPreviousDate(FldValue);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5100957, 'OnBeforeCodeunitParameter', '', false, false)]
    local procedure HandleBeforeCodeunitParameterOnDISMappingCodeunitMgt(var MappingCodeunit : Record "DIS - Mapping Codeunit");
    var
        RegisterMgt : Codeunit "DIS - Mapping Register Mgt.";
        TempSetup : Record "DIS - Setup";
        EntryWarnTxt : Text;
    begin

        if MappingCodeunit."Codeunit Parameter" <> 'ERRORONPOST' then
          exit;

        TempSetup.GET;

        EntryWarnTxt := RegisterMgt.GetVariableTxt(FORMAT(TempSetup."Entry Variables Editable"::EntryWarningText));
        if EntryWarnTxt <> '' then
          ERROR(EntryWarnTxt);
    end;

    procedure "--- Source Code Tag ---"();
    begin
    end;

    local procedure CurrMonthFilter(var FldValue : Variant);
    var
        FirstDate : Date;
        LastDate : Date;
    begin

        FirstDate := CALCDATE('<-CM>',TODAY);
        LastDate := CALCDATE('<CM>',TODAY);
        FldValue := STRSUBSTNO('%1..%2',FirstDate,LastDate);
    end;

    local procedure DateTimeToDate(var FldValue : Variant);
    var
        DateValue : Date;
        DateStr : Text;
    begin

        DateStr := COPYSTR(FldValue,1,10);
        DateStr := COPYSTR(DateStr, 6, 2) + COPYSTR(DateStr, 9, 2) + COPYSTR(DateStr, 3, 2);
        EVALUATE(DateValue,DateStr);
        FldValue := DateValue;
    end;
    // >> AMC-89
    local procedure DatetoPreviousDate(var FldValue : Variant);
    var
        FirstDate : Date;
        LastDate : Date;
    begin
        FldValue := CALCDATE('<-1D>',FldValue);      
    end;
    // << AMC-89
}

