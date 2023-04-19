codeunit 57502 ReservStatusProcess
{
    procedure AutoReservSalesOrder(SalesHeader: Record "Sales Header");
    var
        SalesLine: Record "Sales Line";
        ReservPage: Page Reservation;
        ResStatus: Option "To be processed","No reservation","Partly","Completely";
    begin
        //error('2' + format(SalesHeader."No."));
        SalesLine.RESET;
        SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.SetFilter(Reserve, '<>%1', SalesLine.Reserve::Never);
        IF SalesLine.FindSet() then
            Repeat
                If (SalesLine."Outstanding Qty. (Base)" - SalesLine."Reserved Qty. (Base)") > 0 THEN begin
                    //ReservEntry.SetIgnoreTracking(True);
                    ReservPage.SetSalesLine(SalesLine);
                    ReservPage.AutoReserve;
                end;
            until SalesLine.Next() = 0;

        ResStatus := GetReservStatus(SalesHeader);
        If ResStatus <> SalesHeader."Reservation Status" then Begin
            SalesHeader."Reservation Status" := ResStatus;
            SalesHeader.Modify();
        end;
    end;

    procedure GetReservStatus(SalesHeader: Record "Sales Header") ReturnValue: Option
    var
        SalesLine1: Record "Sales Line";
        FullReserv: Boolean;
    begin
        FullReserv := true;
        SalesLine1.RESET;
        SalesLine1.SetRange(SalesLine1."Document Type", SalesHeader."Document Type"::Order);
        SalesLine1.SetRange("Document No.", SalesHeader."No.");
        SalesLine1.SetRange(Type, SalesLine1.Type::Item);
        SalesLine1.SetFilter("No.", '<>%1', '');
        SalesLine1.SetFilter(Reserve, '<>%1', SalesLine1.Reserve::Never);
        IF SalesLine1.FindSet() then
            Repeat
                If (SalesLine1."Outstanding Qty. (Base)") <> SalesLine1."Reserved Qty. (Base)" THEN begin
                    FullReserv := false;
                end;
            until SalesLine1.Next() = 0;
        If FullReserv then
            ReturnValue := SalesHeader."Reservation Status"::Completely
        else
            ReturnValue := SalesHeader."Reservation Status"::Partly;
    end;
}