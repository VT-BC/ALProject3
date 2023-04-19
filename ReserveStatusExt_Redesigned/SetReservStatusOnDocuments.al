codeunit 57500 SetReservStatus
{
    TableNo = "Sales Header";

    var
        SalesHeader: Record "Sales Header";
        ResMngmt: Codeunit ReservStatusProcess;

    trigger OnRun();
    begin
        ProcessSales();
    end;

    local procedure ProcessSales()
    begin
        SalesHeader.RESET;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", '101011');
        IF SalesHeader.FindFirst() then
            repeat
                Clear(ResMngmt);
                IF SalesHeader."Reservation Status" <> SalesHeader."Reservation Status"::"To be processed" then begin
                    SalesHeader."Reservation Status" := SalesHeader."Reservation Status"::"To be processed";
                    Salesheader.Modify();
                end;

                ResMngmt.AutoReservSalesOrder(SalesHeader);

                IF SalesHeader."Reservation Status" <> SalesHeader."Reservation Status"::"To be processed" then
                    SalesHeader.MODIFY;
            until SalesHeader.Next() = 0;
    end;
}